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

# Recebe uma imagem e o tipo do kernel
# Exemplo chamada: dilatation(imagem, 1)
def edgeDetectionLaplace(image, type):
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
                    # Multiplica o pixel pelo pixel kernel correspondente
                    value += image[newX][newY] * kernel.flat[index]



            imageEdgeD[x][y] = np.clip(value, 0, 255)

    return imageEdgeD

##### Funções do exercicio 2 #####
# Novo modo de obter pixels vizinhos

def gauss_create_kernel(sigma=1, size_x=3, size_y=3):
    '''
    Create normal (gaussian) distribuiton
    '''
    x, y = np.meshgrid(np.linspace(-1, 1, size_x), np.linspace(-1, 1, size_y))
    calc = 1 / ((2 * np.pi * (sigma ** 2)))
    exp = np.exp(-(((x ** 2) + (y ** 2)) / (2 * (sigma ** 2))))

    return exp * calc

# Média
def mean(image, tam):

    w, h = image.shape
    #print(w,h)

    # Criando matriz que irá receber os valores
    imageMean = np.zeros((w, h), np.uint8)

    if tam == 3:
        kernel = np.array([[1/9,1/9,1/9],[1/9,1/9,1/9], [1/9,1/9,1/9]])
        tamB = 1
    elif tam == 5:
        kernel = [[1/25]*25] * 25
        tamB = 2
    elif tam == 7:
        kernel = [[1 / 49] * 49] * 49
        tamB = 3
    else:
        print("Tamanho não suportado!!!")
        return

    # Adiciona borda virtual
    image_copy = np.pad(image.copy(), tamB, mode="constant")

    #print(image_copy[0:10,0:10])
    #print(image_copy[tamB-1:tam,tamB-1:tam])
    #print(image_copy[tamB:tam,tamB:tam])

    for x in range(w):
        for y in range(h):
            neighbourPixels = image_copy[x:x+tam,y:y+tam]
            #print(neighbourPixels)

            value = 0

            for i in range(tam):
                for j in range(tam):
                    value += neighbourPixels[i][j] * kernel[i][j]

            imageMean[x][y] = np.uint8(np.clip(value, 0, 255))
            #print(x,y)

    return imageMean

# Gaussiano
def gaussian(image, tam):

    w, h = image.shape
    #print(w,h)

    # Criando matriz que irá receber os valores
    imageGaus = np.zeros((w, h), np.uint8)

    # https://www.nicolaromano.net/wp-content/uploads/2020/12/gaussian_kernels.png
    if tam == 3:
        kernel = gauss_create_kernel(1, tam, tam)
        tamB = 1
    elif tam == 5:
        kernel = gauss_create_kernel(1, tam,tam)
        tamB = 2
    elif tam == 7:
        kernel = gauss_create_kernel(1, tam,tam)
        tamB = 3
    else:
        print("Tamanho não suportado!!!")
        return

    # Adiciona borda virtual
    image_copy = np.pad(image.copy(), tamB, mode="constant")

    for x in range(w):
        for y in range(h):

            neighbourPixels = image_copy[x:x+tam,y:y+tam]

            value = 0
            #print(neighbourPixels)
            #print(kernel)

            for i in range(tam):
                for j in range(tam):
                    value += neighbourPixels[i][j] * kernel[i][j]
                    #print(value)

            value = value/np.sum(kernel)
            #imageGaus[x][y] = np.sum(np.multiply(kernel, neighbourPixels))/np.sum(kernel)
            imageGaus[x][y] = np.uint8(np.clip(value, 0, 255))
            #imageGaus[x][y] = value

    return imageGaus

# Mediana
def median(image, tam):

    w, h = image.shape
    #print(w,h)

    # Criando matriz que irá receber os valores
    imageMedian = np.zeros((w, h), np.uint8)

    if tam == 3:
        tamB = 1
    elif tam == 5:
        tamB = 2
    elif tam == 7:
        tamB = 3
    else:
        print("Tamanho não suportado!!!")
        return

    # Adiciona borda virtual
    image_copy = np.pad(image.copy(), tamB, mode="constant")

    #print(image_copy[0:10,0:10])
    #print(image_copy[tamB-1:tam,tamB-1:tam])
    #print(image_copy[tamB:tam,tamB:tam])

    for x in range(w):
        for y in range(h):

            neighbourPixels = image_copy[x:x+tam,y:y+tam]

            value = np.sort(np.reshape(neighbourPixels, -1))
            imageMedian[x][y] = value[int((tam**2)/2)]


    return imageMedian

# Laplace
def laplacian(image, type, c):

    w, h = image.shape
    #print(w,h)

    # Criando matriz que irá receber os valores
    imageLaplace = np.zeros((w, h), np.uint8)

    imageLa = edgeDetectionLaplace(image, type)

    for x in range(w):
        for y in range(h):

            value = image[x][y] + c * imageLa[x][y]
            imageLaplace[x][y] = np.uint8(np.clip(value, 0, 255))

    return imageLaplace

import cv2
# Unsharp
def unsharp(image, tam, k):

    w, h = image.shape
    #print(w,h)

    # Criando matriz que irá receber os valores
    imageUnsharp = np.zeros((w, h), np.uint8)

    imageSuav = gaussian(image, tam)

    '''
    for x in range(w):
        for y in range(h):

            value = int(image[x][y]) - int(imageSuav[x][y])
            value = image[x][y] + k * value
            imageUnsharp[x][y] = np.uint8(np.clip(value, 0, 255))
    '''
    matAux = (image - imageSuav)
    imageUnsharp = image + k*matAux

    return imageUnsharp

# Roberts
def roberts(image):

    w, h = image.shape
    #print(w,h)

    # Criando matriz que irá receber os valores
    imageRob = np.zeros((w, h), np.uint8)

    kernel1 = np.array([[0, 1], [-1, 0]])
    kernel2 = np.array([[1,0], [0,-1]])
    tam = 2

    # Adiciona borda virtual
    image_copy = np.pad(image.copy(), (0, 1), mode="constant")

    for x in range(w):
        for y in range(h):

            neighbourPixels = image_copy[x:x + tam, y:y + tam]
            value1 = 0
            value2 = 0
            value = 0

            for i in range(tam):
                for j in range(tam):
                    pixel = neighbourPixels[i][j]
                    value1 += pixel * kernel1[i][j]
                    value2 += pixel * kernel2[i][j]

            value = abs(value1) + abs(value2)
            imageRob[x][y] = np.uint8(np.clip(value, 0, 255))

    return imageRob

# Sobel
def sobel(image):

    w, h = image.shape
    #print(w,h)

    # Criando matriz que irá receber os valores
    imageSobel = np.zeros((w, h), np.uint8)


    kernel1 = np.array([[1, 2, 1], [0, 0, 0], [-1, -2, -1]])
    kernel2 = np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]])

    tamB = 1
    tam = 3

    # Adiciona borda virtual
    image_copy = np.pad(image.copy(), tamB, mode="constant")

    #print(image_copy[0:10,0:10])
    #print(image_copy[tamB-1:tam,tamB-1:tam])
    #print(image_copy[tamB:tam,tamB:tam])

    for x in range(w):
        for y in range(h):

            neighbourPixels = image_copy[x:x + tam, y:y + tam]
            value1 = 0
            value2 = 0

            for i in range(tam):
                for j in range(tam):
                    pixel = neighbourPixels[i][j]
                    value1 += pixel * kernel1[i][j]
                    value2 += pixel * kernel2[i][j]

            value = abs(value1) + abs(value2)
            imageSobel[x][y] = np.uint8(np.clip(value, 0, 255))

    return imageSobel

