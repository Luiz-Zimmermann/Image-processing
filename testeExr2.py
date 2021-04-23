import cv2
import matplotlib.pyplot as plt
import time
import morfOp as op
import numpy as np


# Caminho das imagens
imageSuav = "data/a.tif"
#imageSuav = "data/t1.jpg"
imageLaplace = "data/lua.tif"
imageMedian = "data/placa.tif"
imageSharp = "data/dip.tif"
imageRobr = "data/cir.tif"

savePath = "resultados/"


if __name__ == "__main__":


    #### Operações básicas ####
    print("#### Suavização ####")

    grayImage = cv2.imread(imageSuav, 0)

    print("#### Media ####")
    # Kernel: 3 p/ 3x3 e 5 p/ 5x5 e 7 p/ 7x7
    imageMean3 = op.mean(grayImage, 3)
    print("Media 3x3 pronto !!")
    imageMean5 = op.mean(grayImage, 5)
    print("Media 5x5 pronto !!")
    imageMean7 = op.mean(grayImage, 7)
    print("Media 7x7 pronto !!")

    print("Media pronta !!")
    cv2.imshow("Original Media", grayImage)
    cv2.imshow("Media 3x3", imageMean3)
    cv2.imshow("Media 5x5", imageMean5)
    cv2.imshow("Media 7x7", imageMean7)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    print("#### Gaussiano ####")
    # Kernel: 3 p/ 3x3 e 5 p/ 5x5 e 7 p/ 7x7
    imageGaus3 = op.gaussian(grayImage, 3)
    print("Gaus 3x3 pronto !!")
    imageGaus5 = op.gaussian(grayImage, 5)
    print("Gaus 5x5 pronto !!")
    imageGaus7 = op.gaussian(grayImage, 7)
    print("Gaus 7x7 pronto !!")

    print("Gaussiano pronto !!")
    cv2.imshow("Original Gaussiano", grayImage)
    cv2.imshow("Gaussiano 3x3", imageGaus3)
    cv2.imshow("Gaussiano 5x5", imageGaus5)
    cv2.imshow("Gaussiano 7x7", imageGaus7)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    grayImage = cv2.imread(imageMedian, 0)

    print("#### Mediana ####")
    # Kernel: 3 p/ 3x3 e 5 p/ 5x5 e 7 p/ 7x7
    imageMedian3 = op.median(grayImage, 3)
    print("Mediana 3x3 pronto !!")
    imageMedian5 = op.median(grayImage, 5)
    print("Mediana 5x5 pronto !!")
    imageMedian7 = op.median(grayImage, 7)
    print("Mediana 7x7 pronto !!")

    cv2.imshow("Original Mediana", grayImage)
    cv2.imshow("Mediana 3x3", imageMedian3)
    cv2.imshow("Mediana 5x5", imageMedian5)
    cv2.imshow("Mediana 7x7", imageMedian7)
    cv2.waitKey(0)
    cv2.destroyAllWindows()


    print("#### Sharpening ####")
    grayImage = cv2.imread(imageLaplace, 0)

    print("#### Laplaciano ####")
    # Há 2 tipos de kernel.
    # Tipo 1: kernel em formato de cruz com o valor 4 no centro e os demais valores igual a -1
    # Tipo 2: kernel com o valor 8 no centro e nas demais posições ao redor o valor -1
    # 3º parametro: valor c = 1
    imageLaplace1 = op.laplacian(grayImage, 1, 1)
    print("Laplace kernel 1 pronto !!")
    imageLaplace2 = op.laplacian(grayImage, 2, 1)
    print("Laplace kernel 2 pronto !!")

    cv2.imshow("Original Laplace", grayImage)
    cv2.imshow("Laplaciano kernel 1", imageLaplace1)
    cv2.imshow("Laplaciano kernel 2", imageLaplace1)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    grayImage = cv2.imread(imageSharp, 0)

    # 2º parametro: tamanho do kerel para a suavização, 3 p/ 3x3 e 5 p/ 5x5 e 7 p/ 7x7
    # 3º parametro: valor k >= 0
    imageUnsharp = op.unsharp(grayImage, 3, 1)
    print("Unsharp 3x3 pronto !!")
    imageHighb= op.unsharp(grayImage, 3, 2)
    print("High-boost pronto !!")

    cv2.imshow("Original Unsharp", grayImage)
    cv2.imshow("Unsharp  ", imageUnsharp)
    cv2.imshow("High boost  ", imageHighb)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

    image = cv2.cvtColor(cv2.imread(imageRobr), cv2.COLOR_BGR2RGB)
    grayImage = op.convert2gray(image)
    print("Gray done !!")

    # Há 2 tipos de kernel.
    # Tipo 1: kernel em formato de cruz com o valor 4 no centro e os demais valores igual a -1
    # Tipo 2: kernel com o valor 8 no centro e nas demais posições ao redor o valor -1
    imgEdgeD1 = op.edgeDetectionLaplace(grayImage, 1)
    # 2º parametro: tamanho do kerel para a suavização, 3 p/ 3x3 e 5 p/ 5x5 e 7 p/ 7x7
    # 3º parametro: valor k >= 0
    imageRoberts = op.roberts(grayImage)
    print("Roberts pronto !!")
    imageSobel = op.sobel(grayImage)
    print("Sobel pronto !!")

    imageLaplace = op.edgeDetectionLaplace(grayImage, 1)
    print("Laplace pronto !!")
    imageCanny = cv2.Canny(grayImage, 0, 255)

    cv2.imshow("Original ", grayImage)
    cv2.imshow("Roberts  ", imageRoberts)
    cv2.imshow("Sobel   ", imageSobel)
    cv2.imshow("Laplace", imageLaplace)
    cv2.imshow("cv2 Canny", imageCanny)
    cv2.waitKey(0)
    cv2.destroyAllWindows()






