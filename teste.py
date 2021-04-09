import cv2
import matplotlib.pyplot as plt
import time
import morfOp as op


# Caminho das imagens
imagePath = "data/carro.png"
image1bitwise = "data/TI.tif"
image2bitwise = "data/UTK.tif"
imageOpMorf = "data/texto.tif"
imageOpFilt = "data/finger.tif"
imageEdgeD = "data/borda.tif"

savePath = "resultados/"

if __name__ == "__main__":


    #### Operações básicas ####
    print("#### Operações básicas ####")

    image = cv2.cvtColor(cv2.imread(imagePath), cv2.COLOR_BGR2RGB)
    tStart = time.time()
    grayImage = op.convert2gray(image)
    tEnd = time.time() - tStart
    print("Gray done !!", tEnd, "s")

    tStart = time.time()
    binImage = op.convert2Bin(grayImage, 127)
    tEnd = time.time() - tStart
    print("Bin done !!", tEnd, "s")

    # Irá mostrar a imagem com as cores trocadas devido o padrão do cv2 ser BGR
    cv2.imshow("Original", image)
    cv2.imshow("Gray", grayImage)
    cv2.imshow("Bin", binImage)
    cv2.waitKey(0)
    cv2.imwrite(savePath+"Original.png", image)
    cv2.imwrite(savePath + "Gray.png", grayImage)
    cv2.imwrite(savePath + "Bin.png", binImage)
    cv2.destroyAllWindows()


    #### Operações bitwise ####
    print()
    print("#### Operações bitwise ####")

    tStart = time.time()
    notImage = op.bitwiseNOT(binImage)
    tEnd = time.time() - tStart
    print("Not done !!", tEnd, "s")


    # Utilizando o cv2 para abrir e transformar pois é mais rápido
    img1 = cv2.cvtColor(cv2.imread(image1bitwise), cv2.COLOR_BGR2GRAY)
    _, img1 = cv2.threshold(img1, 127, 255, cv2.THRESH_BINARY)
    img2 = cv2.cvtColor(cv2.imread(image2bitwise), cv2.COLOR_BGR2GRAY)
    _, img2 = cv2.threshold(img2, 127, 255, cv2.THRESH_BINARY)

    tStart = time.time()
    andImage = op.bitwiseAND(img1, img2)
    tEnd = time.time() - tStart
    print("AND done !!", tEnd, "s")

    tStart = time.time()
    orImage = op.bitwiseOR(img1, img2)
    tEnd = time.time() - tStart
    print("OR done !!", tEnd, "s")

    tStart = time.time()
    xorImage = op.bitwiseXOR(img1, img2)
    tEnd = time.time() - tStart
    print("XOR done !!", tEnd, "s")

    cv2.imshow("Original Bin", binImage)
    cv2.imshow("Not", notImage)
    cv2.waitKey(0)
    cv2.imwrite(savePath + "Original Bin.png", binImage)
    cv2.imwrite(savePath + "Not.png", notImage)
    cv2.destroyAllWindows()

    cv2.imshow("img1", img1)
    cv2.imshow("img2", img2)
    cv2.imshow("and", andImage)
    cv2.imshow("or", orImage)
    cv2.imshow("xor", xorImage)
    cv2.waitKey(0)
    cv2.imwrite(savePath + "img1.png", img1)
    cv2.imwrite(savePath + "img2.png", img2)
    cv2.imwrite(savePath + "and.png", andImage)
    cv2.imwrite(savePath + "or.png", orImage)
    cv2.imwrite(savePath + "xor.png", xorImage)

    cv2.destroyAllWindows()

    #### Operações morfológicas ####
    print()
    print("#### Operações morfológicas ####")


    img = cv2.cvtColor(cv2.imread(imageOpMorf), cv2.COLOR_BGR2GRAY)
    _, img = cv2.threshold(img, 127, 255, cv2.THRESH_BINARY)
    
    newImgD = img.copy()
    newImgE = img.copy()
    
    # 3 p/ 3x3 e 5 p/ 5x5
    tamKernel = 3

    tStart = time.time()
    dilatImage = op.dilatation(img, tamKernel)
    tEnd = time.time() - tStart
    print("Dilataion done !!", tEnd, "s")

    tStart = time.time()
    erosImage = op.erosion(img, tamKernel)
    tEnd = time.time() - tStart
    print("Erosion done !!", tEnd, "s")

    kernel = cv2.getStructuringElement(cv2.MORPH_CROSS, (tamKernel, tamKernel))

    tStart = time.time()
    cv2Dilat = cv2.dilate(newImgD, kernel, iterations=1)
    tEnd = time.time() - tStart
    print("Dilataion by cv2 done !!", tEnd, "s")

    tStart = time.time()
    cv2Eros = cv2.erode(newImgE, kernel, iterations=1)
    tEnd = time.time() - tStart
    print("Erosion by cv2 done !!", tEnd, "s")

    cv2.imshow("original Morf", img)
    cv2.imshow("dilatImage", dilatImage)
    cv2.imshow("dilatImageCV2", cv2Dilat)
    cv2.imshow("erosImage", erosImage)
    cv2.imshow("erosImageCV2", cv2Eros)
    cv2.waitKey(0)
    cv2.imwrite(savePath + "original Morf.png", img)
    cv2.imwrite(savePath + "dilatImage.png", dilatImage)
    cv2.imwrite(savePath + "erosImage.png", erosImage)

    cv2.destroyAllWindows()

    #### Filtragem ####
    print()
    print("#### Filtragem ####")

    img = cv2.cvtColor(cv2.imread(imageOpFilt), cv2.COLOR_BGR2GRAY)
    _, img = cv2.threshold(img, 127, 255, cv2.THRESH_BINARY)

    # 3 p/ 3x3 e 5 p/ 5x5
    tamKernel = 3

    # Filtragem
    tStart = time.time()
    imgOpen = op.opening(img, tamKernel)
    tEnd = time.time() - tStart
    print("Opening done !!", tEnd, "s")

    tStart = time.time()
    imgClose = op.closing(imgOpen, tamKernel)
    tEnd = time.time() - tStart
    print("Closing done !!", tEnd, "s")

    cv2.imshow("original Filtro", img)
    cv2.imshow("Open", imgOpen)
    cv2.imshow("Close", imgClose)
    cv2.waitKey(0)
    cv2.imwrite(savePath + "original Filtro.png", img)
    cv2.imwrite(savePath + "Open.png", imgOpen)
    cv2.imwrite(savePath + "Close.png", imgClose)
    cv2.destroyAllWindows()

    #### Detecção de bordas ####
    print()
    print("#### Detecção de bordas ####")

    img = cv2.cvtColor(cv2.imread(imageEdgeD), cv2.COLOR_BGR2GRAY)
    _, img = cv2.threshold(img, 127, 255, cv2.THRESH_BINARY)

    # Há 2 tipos de kernel.
    # Tipo 1: kernel em formato de cruz com o valor 4 no centro e os demais valores igual a -1
    # Tipo 2: kernel com o valor 8 no centro e nas demais posições ao redor o valor -1
    tStart = time.time()
    imgEdgeD1 = op.edgeDetection(img, 1)
    tEnd = time.time() - tStart
    print("Edge detection kernel 1 done !!", tEnd, "s")

    tStart = time.time()
    imgEdgeD2 = op.edgeDetection(img, 2)
    tEnd = time.time() - tStart
    print("Edge detection kernel 2 done !!", tEnd, "s")

    cv2.imshow("original Edge", img)
    cv2.imshow("D kernel 1", imgEdgeD1)
    cv2.imshow("D kernel 2", imgEdgeD2)

    cv2.waitKey(0)
    cv2.imwrite(savePath + "original Edge.png", img)
    cv2.imwrite(savePath + "D kernel 1.png", imgEdgeD1)
    cv2.imwrite(savePath + "D kernel 2.png", imgEdgeD2)
    cv2.destroyAllWindows()

    print()
    print("Fim das demonstrações")