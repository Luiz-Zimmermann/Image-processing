import numpy as np

# Trabalha com imagens RGB
def convert2gray(image):

    w, h, nC = image.shape

    # Criando matriz que irá receber os valores
    imageGray = np.zeros((w, h), np.uint8)

    for y in range(h):
        for x in range(w):

            # Pegando os valores de cada canal
            r = image[x][y][0]
            g = image[x][y][1]
            b = image[x][y][2]

            # Formula para converter um valor RGB para cinza
            grayValue = int(0.299 * r + 0.587 * g + 0.114 * b)

            imageGray[x][y] = grayValue

    return imageGray

# Recebe uma imagem em grayscale e o threshold.
# Exemplo chamada: dilatation(imagem, 127)
def convert2Bin(image, threshold):

    w, h = image.shape

    imageBin = np.zeros((w, h), np.uint8)

    for y in range(h):
        for x in range(w):

            pixelValue = image[x][y]

            if pixelValue > threshold:
                imageBin[x][y] = 255
            else:
                imageBin[x][y] = 0

    return imageBin

def bitwiseNOT(image):

    w, h = image.shape
    imageNot = np.zeros((w, h), np.uint8)

    for y in range(h):
        for x in range(w):

            pixelValue = image[x][y]

            imageNot[x][y] = 255 - pixelValue

    return imageNot

# As imagens precisam ter o mesmo tamanho
def bitwiseAND(image1, image2):

    if image1.shape[0] != image2.shape[0] or image1.shape[1] != image2.shape[1]:
        print("As imagens não possuem as mesma dimenções!!", "Imagem 1:", image1.shape, "Imagem 2:", image2.shape)
        return

    w, h = image1.shape
    imageAND = np.zeros((w, h), np.uint8)

    for y in range(h):
        for x in range(w):

            v1 = image1[x][y]
            v2 = image2[x][y]

            pixelValue = v1 and v2

            imageAND[x][y] = pixelValue

    return imageAND

# As imagens precisam ter o mesmo tamanho
def bitwiseOR(image1, image2):

    if image1.shape[0] != image2.shape[0] or image1.shape[1] != image2.shape[1]:
        print("As imagens não possuem as mesma dimenções!!", "Imagem 1:", image1.shape, "Imagem 2:", image2.shape)
        return

    w, h = image1.shape
    imageOR = np.zeros((w, h), np.uint8)

    for y in range(h):
        for x in range(w):

            v1 = image1[x][y]
            v2 = image2[x][y]

            pixelValue = v1 or v2

            imageOR[x][y] = pixelValue

    return imageOR

# As imagens precisam ter o mesmo tamanho
def bitwiseXOR(image1, image2):

    if image1.shape[0] != image2.shape[0] or image1.shape[1] != image2.shape[1]:
        print("As imagens não possuem as mesma dimenções!!", "Imagem 1:", image1.shape, "Imagem 2:", image2.shape)
        return

    w, h = image1.shape
    imageXOR = np.zeros((w, h), np.uint8)

    for y in range(h):
        for x in range(w):

            v1 = image1[x][y]
            v2 = image2[x][y]

            pixelValue = v1 ^ v2

            imageXOR[x][y] = pixelValue

    return imageXOR

# Recebe uma imagem binarizada e o tamanho do kernel, 3x3 ou 5x5.
# Exemplo chamada: dilatation(imagem, 3)
def dilatation(image, tam):
    w, h = image.shape

    # Criando matriz que irá receber os valores
    imageDilat = np.zeros((w, h), np.uint8)

    # https://homepages.inf.ed.ac.uk/rbf/HIPR2/dilate.htm

    if tam == 3:
        kernel = np.array([[0,255,0],[255,255,255], [0,255,0]])
        kernelPositions = [(-1,-1),(0,-1),(1,-1),
                           (-1,0), (0,0), (1,0),
                           (-1,1), (0,1), (1,1)]
    elif tam == 5:
        kernel = np.array([[0, 0, 255, 0, 0], [0, 0, 255, 0, 0], [255, 255, 255, 255, 255], [0, 0, 255, 0, 0], [0, 0, 255, 0, 0]])
        kernelPositions = [(-2,-2), (-1, -2), (0, -2), (1, -2), (2, -2),
                           (-2,-1), (-1, -1), (0, -1), (1, -1), (2, -1),
                           (-2, 0), (-1,  0), (0,  0), (1,  0), (2,  0),
                           (-2, 1), (-1,  1), (0,  1), (1,  1), (2,  1),
                           (-2, 2), (-1,  2), (0,  2), (1,  2), (2,  2)]
    else:
        print("Tamanho não suportado!!!")
        return

    for y in range(h):
        for x in range(w):

            value = 0
            for position, index in zip(kernelPositions, range(len(kernelPositions))):

                # Novas posições para pegar os pixeis visinhos
                newX = x + position[0]
                newY = y + position[1]

                # Senão estiver fora dos limites
                if (newX >= 0 and newX < w) and (newY >= 0 and newY < h):
                    # Se houver um pixel visinho foreground e bater com o elemento do kernel, então o pixel vira foreground
                    if image[newX][newY] and kernel.flat[index] == 255:
                        value = 255
                        break

            imageDilat[x][y] = value

    return imageDilat

# Recebe uma imagem binarizada e o tamanho do kernel, 3x3 ou 5x5.
# Exemplo chamada: erosion(imagem, 3)
def erosion(image, tam):
    w, h = image.shape

    # Criando matriz que irá receber os valores
    imageEros = np.zeros((w, h), np.uint8)

    # https://homepages.inf.ed.ac.uk/rbf/HIPR2/dilate.htm

    if tam == 3:
        kernel = np.array([[0,255,0],[255,255,255], [0,255,0]])
        kernelPositions = [(-1,-1),(0,-1),(1,-1),
                           (-1,0), (0,0), (1,0),
                           (-1,1), (0,1), (1,1)]
    elif tam == 5:
        kernel = np.array([[0, 0, 255, 0, 0], [0, 0, 255, 0, 0], [255, 255, 255, 255, 255], [0, 0, 255, 0, 0], [0, 0, 255, 0, 0]])
        kernelPositions = [(-2,-2), (-1, -2), (0, -2), (1, -2), (2, -2),
                           (-2,-1), (-1, -1), (0, -1), (1, -1), (2, -1),
                           (-2, 0), (-1,  0), (0,  0), (1,  0), (2,  0),
                           (-2, 1), (-1,  1), (0,  1), (1,  1), (2,  1),
                           (-2, 2), (-1,  2), (0,  2), (1,  2), (2,  2)]
    else:
        print("Tamanho não suportado!!!")
        return

    for y in range(h):
        for x in range(w):

            value = 255
            for position, index in zip(kernelPositions, range(len(kernelPositions))):

                # Novas posições para pegar os pixeis visinhos
                newX = x + position[0]
                newY = y + position[1]

                # Senão estiver fora dos limites
                if (newX >= 0 and newX < w) and (newY >= 0 and newY < h):
                    # Se houver um pixel visinho background e bater com o elemento do kernel, então o pixel vira background
                    if image[newX][newY] == 0 and kernel.flat[index] == 255:
                        value = 0
                        break

            imageEros[x][y] = value

    return imageEros

# Recebe uma imagem binarizada e o tamanho do kernel, 3x3 ou 5x5.
# Exemplo chamada: opening(imagem, 3)
def opening(image, tam):

    # Abertura é a dilatação de uma erosão
    return dilatation(erosion(image, tam), tam)

# Recebe uma imagem binarizada e o tamanho do kernel, 3x3 ou 5x5.
# Exemplo chamada: closing(imagem, 3)
def closing(image, tam):

    # Fechamento é a erosão de uma dilatação
    return erosion(dilatation(image,tam), tam)

# Recebe uma imagem binarizada e o tipo do kernel
# Exemplo chamada: dilatation(imagem, 1)
def edgeDetection(image, type):
    w, h = image.shape

    # Criando matriz que irá receber os valores
    imageEdgeD = np.zeros((w, h), np.uint8)

    # https://homepages.inf.ed.ac.uk/rbf/HIPR2/dilate.htm

    if type == 1:
        kernel = np.array([[0,-1,0],[-1,4,-1], [0,-1,0]])
        kernelPositions = [(-1,-1),(0,-1),(1,-1),
                           (-1,0), (0,0), (1,0),
                           (-1,1), (0,1), (1,1)]
    elif type == 2:
        kernel = np.array([[-1,-1,-1],[-1,8,-1], [-1,-1,-1]])
        kernelPositions = [(-1,-1),(0,-1),(1,-1),
                           (-1,0), (0,0), (1,0),
                           (-1,1), (0,1), (1,1)]

    else:
        print("Tamanho não suportado!!!")
        return

    for y in range(h):
        for x in range(w):
            value = 0
            for position, index in zip(kernelPositions, range(len(kernelPositions))):

                # Novas posições para pegar os pixeis visinhos
                newX = x + position[0]
                newY = y + position[1]

                # Senão estiver fora dos limites
                if (newX >= 0 and newX < w) and (newY >= 0 and newY < h):
                    # Se houver um pixel visinho background e bater com o elemento do kernel, então o pixel vira background
                    value += image[newX][newY] * kernel.flat[index]



            imageEdgeD[x][y] = np.uint8(value)

    return imageEdgeD