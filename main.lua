_G.cg   = require "Src/funcoesCG"

ImagemData = CreateImage(800,800)
Imagem = nil
Quadrado = CriaPoligono()
Textura = love.image.newImageData("Textura/gato.jpg")

Triangulo = CriaPoligono()

Color = {{0,0,255},
         {0,255,0},
         {255,0,0}--[[,
        {0,0,0}]]}

--------------------------------------------------------
function love.load()
    InserePonto(Quadrado,{10,10,0,0})
    InserePonto(Quadrado,{100,10,1,0})
    InserePonto(Quadrado,{100,100,1,1})
    InserePonto(Quadrado,{10,100,0,1})
    ---------------------------------
    InserePonto(Triangulo,{300, 0, 0, 0})
    --InserePonto(Triangulo,{300, 0, 1, 0})
    InserePonto(Triangulo,{600, 300, 1, 1})
    InserePonto(Triangulo,{0, 300, 0, 1})


    --ScanLineT(ImagemData, Quadrado, Textura)
    --DesenhaPoligono(ImagemData, Quadrado, 255, 0 , 0)
    --ScanLineT(ImagemData, Triangulo, Textura)
    --DesenhaPoligono(ImagemData, Triangulo, 255, 255 , 0)
    ScanLinePontos(ImagemData, Triangulo, Color)
    --ScanLineColor(ImagemData, Quadrado,255,255,0)
    --FloodFill(ImagemData, 25, 25, 0,0,0, 255, 255, 0)
    --FloodFill(ImagemData, 250, 25, 0,0,0, 255, 255, 255)
    --BoundaryFill(ImagemData, 15, 25, 255,0,0, 255,255,255)
    --R, G, B = GetPixelText(Textura, 0.5, 0.5)
    Imagem = Convert(ImagemData)
end

function love.update(dt)
    
end

function love.draw()
    --love.graphics.print(tostring(R).." "..tostring(G).." "..tostring(B), 10, 10)
    love.graphics.draw(Imagem)
end