_G.cg   = require "funcoesCG"

ImagemData = CreateImage(800,800)
Imagem = nil
Quadrado = CriaPoligono()

Triangulo = CriaPoligono()


function love.load()
    InserePonto(Quadrado,{10,10})
    InserePonto(Quadrado,{500,10})
    InserePonto(Quadrado,{500,500})
    InserePonto(Quadrado,{10,500})
    ---------------------------------
    InserePonto(Triangulo,{20, 70})
    InserePonto(Triangulo,{50, 20})
    InserePonto(Triangulo,{70, 70})
    --DesenhaPoligono(ImagemData, Quadrado, 255, 0 , 0)
    DesenhaPoligono(ImagemData, Triangulo, 255, 255 , 0)
    ScanLine(ImagemData, Triangulo,255,255,0)
    --FloodFill(ImagemData, 25, 25, 0,0,0, 255, 255, 0)
    --FloodFill(ImagemData, 250, 25, 0,0,0, 255, 255, 255)
    --BoundaryFill(ImagemData, 15, 25, 255,0,0, 255,255,255)
    Imagem = Convert(ImagemData)
end

function love.update(dt)
    
end

function love.draw()
    love.graphics.draw(Imagem)
end