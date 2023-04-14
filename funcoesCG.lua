require "dependences"
require "myEDD"

Stack = Pilha()

function CreateImage(width, height)
    return love.image.newImageData(width, height, "rgba8")
end

--funcao para limpar a imagem passada como argumento
function Clear(img)
    local width, height = img:getDimensions( )
    img = CreateImage(width, height)
end

--funcao que retorna uma imagem convertida que pode ser mostrada na tela
function Convert(rawImageData)
    return love.graphics.newImage(rawImageData)
end

--funcoes para desenhar linha
--funcao que recebe uma imageData e seta um pixel na posicao (x y) na cor (r, g, b)-> valores de 0-255
function SetPixel(buf, x, y, r, g, b)
    --variaveis
    --variaveis maior que zero
    if r > 255 then
        r = 255
    end
    if g > 255 then
        g = 255
    end
    if b > 255 then
        b = 255
    end
    --menor que zero
    if r < 0 or r == nil then
        r = 0
    end
    if g < 0 or g == nil then
        g = 0
    end
    if b < 0 or b == nil then
        b = 0
    end
    ---------------------
    local red =  r / 255
    local green = g / 255
    local blue = b / 255
    local width, height = buf:getDimensions()
    --Tratamento de execoes
    if x >= width  then
        x = width - 1
    end
    if x < 0  then
        x = 0
    end
    if y >= height  then
        y = height - 1
    end
    if y < 0  then
        y = 0
    end

    --chamada da funcao love.ImageData:setPixel
    buf:setPixel(x, y, red, green, blue, 1)
end

function GetPixel(buf, x, y)
    local width, height = buf:getDimensions()
    --Tratamento de execoes
    if x >= width  then
        x = width - 1
    end
    if x < 0  then
        x = 0
    end
    if y >= height  then
        y = height - 1
    end
    if y < 0  then
        y = 0
    end
    local Ra, Ga, Ba, Aa = buf:getPixel(x, y)
    Ra = math.ceil(Ra*255)
    Ga = math.ceil(Ga*255)
    Ba = math.ceil(Ba*255)
    return Ra, Ga, Ba
end
-----------------------------------------------------------------------------------------------
--funcoes Retas
--funcao para desenhar uma linha usando o algoritmo DDA
function DDA(buf, xi, yi, xf, yf, r, g, b)
    local dx = xf-xi
    local dy = yf-yi
    local passos = math.max( math.abs(dx), math.abs(dy))

    if passos == 0 then
        SetPixel(buf, xi, yi, r, g, b)
        return
    end

    local passoX = dx / passos
    local passoY = dy / passos

    for i = 0, passos, 1 do
        local x = math.ceil(xi + (i*passoX)) 
        local y = math.ceil(yi + (i*passoY)) 
        SetPixel(buf, x, y, r, g, b)
    end
end

--funcao para desenhar uma linha usando o algoritmo de Breseham
function Breseham(buf, xi, yi, xf, yf, r, g, b)
    local dx
    local dy
    --tratamento de casos especiais
    --um ponto somente
    if (xi == xf) and (yi == yf)  then
        SetPixel(buf, xi, yi, r, g, b)
        return
    end
    --reta inversa
    if xi > xf then
        local aux = xi
        xi = xf
        xf = aux
    end
    if yi > yf then
        local aux = yi
        yi = yf
        yf = aux
    end
    dx = xf - xi
    dy = yf - yi
    --dy > dx  troca os valores de x e y
    if dy > dx  then
        --troca xi e yi
        local aux = xi
        xi = yi
        yi = aux
        --troca xf e yf
        aux = xf
        xf = yf
        yf = aux
        --troca dx e dy
        aux = dx
        dx = dy
        dy = aux
    end
    --funcao propriamente dita
    local dx2 = 2*dx
    local dy2 = 2*dy 
    local p   = - dx + dy2
    local x   = math.ceil(xi)
    local y   = math.ceil(yi)

    for i = 0, math.abs(dx), 1 do
        SetPixel(buf, x, y, r, g, b)

        x = x + 1
        if p >= 0 then
            y = y + 1
            p = p - dx2 + dy2
        else
            p = p + dy2
        end
    end
end

--funcao para desenhar a linha com antialisg
function DDAAA(buf, xi, yi, xf, yf, r, g, b)
    local dx = xf - xi
    local dy = yf - yi
    local passos = math.max( math.abs(dx), math.abs(dy))

    if passos == 0 then
        SetPixel(buf, xi, yi, r, g, b)
        return
    end

    local passoX = dx / passos
    local passoY = dy / passos

    for i = 0, passos, 1 do
        local x = xi + i*passoX
        local y = yi + i*passoY

        if math.abs(math.ceil(passoX)) == 1 then
            local yd = y - math.floor(y)
            --pega os pixeis
            ------------------------------------------------------------------------
            local ra, ga, ba, aa = buf:getPixel(math.ceil(x), math.floor(y))
            ra = ra * 255
            ga = ga * 255
            ba = ba * 255
            local rp, gp, bp, ap = buf:getPixel(math.ceil(x), math.floor(y+1))
            rp = rp*255
            gp = gp*255
            bp = bp*255
            -------------------------------------------------------------------------
            --seta o primeiro pixel
            local newR = (ra + math.ceil((1-yd)*r)) / 2
            local newB = (ba + math.ceil((1-yd)*b)) / 2
            local newG = (ga +  math.ceil((1-yd)*g)) / 2
           SetPixel(buf, math.ceil(x), math.floor(y),    newR,  newG, newB)

            --seta o segundo pixel
           newR = (rp + math.ceil((yd)*r)) / 2
           newB = (bp + math.ceil((yd)*b)) / 2
           newG = (gp +  math.ceil((yd)*g)) / 2
           SetPixel(buf, math.ceil(x), math.floor(y+1), newR,  newG, newB)
        else
            local xd = x - math.floor(x)
             --pega os pixeis
            ------------------------------------------------------------------------
            local ra, ga, ba, aa = buf:getPixel(math.floor(x), math.ceil(y))
            ra = ra * 255
            ga = ga * 255
            ba = ba * 255
            local rp, gp, bp, ap = buf:getPixel(math.floor(x+1), math.ceil(y))
            rp = rp*255
            gp = gp*255
            bp = bp*255
            -------------------------------------------------------------------------
             --seta o primeiro pixel
             local newR = (ra + math.ceil((1-xd)*r)) / 2
             local newB = (ba + math.ceil((1-xd)*b)) / 2
             local newG = (ga +  math.ceil((1-xd)*g)) / 2
            SetPixel(buf, math.floor(x), math.ceil(y),   newR,  newG, newB)

              --seta o primeiro pixel
            newR = (rp + math.ceil((xd)*r)) / 2
            newB = (bp + math.ceil((xd)*b)) / 2
            newG = (gp +  math.ceil((xd)*g)) / 2
            SetPixel(buf, math.floor(x+1), math.ceil(y), newR,  newG, newB)
        end
    end


end

--funcao que desenha um circulo na tela
function Circle(buf, xc, yc, radius, r, g, b)
    local x = 0
    local y = math.ceil(radius)
    radius = math.abs(radius)
    local p = 1 - radius
    CirclePlotPoints(buf, xc, yc, x, y, r, g, b)

    while x < y do
        x = x + 1
        if p < 0 then
            p = p + 2*x + 1
        else
            y = y - 1
            p = p + 2*(x-y) + 1
        end
        CirclePlotPoints(buf, xc, yc, x, y, r, g, b)
    end
end
--funcao para plotar os pontos do circulo
function CirclePlotPoints(buf,xc, yc, x, y, r, g, b)
    SetPixel(buf, xc + x, yc + y, r, g, b)
    SetPixel(buf, xc - x, yc + y, r, g, b)
    SetPixel(buf, xc + x, yc - y, r, g, b)
    SetPixel(buf, xc - x, yc - y, r, g, b)
    SetPixel(buf, xc + y, yc + x, r, g, b)
    SetPixel(buf, xc - y, yc + x, r, g, b)
    SetPixel(buf, xc + y, yc - x, r, g, b)
    SetPixel(buf, xc - y, yc - x, r, g, b)
end

--funcao que desenha uma Elipse na tela
function Elipse(buf, xc, yc, Rx, Ry, r, g, b)
    local Rx2    = Rx*Rx
    local Ry2    = Ry*Ry
    local twoRx2 = 2*Rx2
    local twoRy2 = 2*Ry2
    local p
    local x      = 0
    local y      = Ry
    local px     = 0
    local py     = twoRx2 * y
    --plota os primeiros pontos
    ElipsePlotPoints(buf,xc, yc, x, y, r, g, b)

    --Regiao 1
    p = math.ceil(Ry2 - (Rx2 * Ry) + (0.25 * Rx2))
    while px < py do
        x = x + 1
        px = px + twoRy2
        if p < 0 then
            p = p + Ry2 + px
        else
            y = y - 1
            py = py - twoRx2
            p = p + Ry2 + px - py
        end
        ElipsePlotPoints(buf,xc, yc, x, y, r, g, b)
    end

    --Regiao 2
    p = math.ceil(Ry2 * (x+0.5)*(x+0.5) + Rx2*(y-1)*(y-1) - Rx2*Ry2)
    while y > 0 do
        y = y - 1
        py = py - twoRx2
        if p > 0 then
            p = p + Rx2 - py
        else
            x = x + 1
            px = px + twoRy2
            p = p + Rx2 - py + px
        end
        ElipsePlotPoints(buf,xc, yc, x, y, r, g, b)
    end
end
--funcao para plotar os pontos da elipse
function ElipsePlotPoints(buf,xc, yc, x, y, r, g, b)
    SetPixel(buf, xc + x, yc + y, r, g, b)
    SetPixel(buf, xc - x, yc + y, r, g, b)
    SetPixel(buf, xc + x, yc - y, r, g, b)
    SetPixel(buf, xc - x, yc - y, r, g, b)
end
--------------------------------------------------------------------------------
--funcoes pintura--
--funcao FloodFill
function FloodFill(buf, x, y, oldR, oldG, oldB, fillR, fillG, fillB)
    local Q = Stack
    Q:Push({x,y})
    while Q:Empty() do
         local n = Q:Pop()
         if n == nil then
            return
         end
         local Ra, Ga, Ba = GetPixel(buf, n[1], n[2])
         Ra = math.ceil(Ra*255)
         Ga = math.ceil(Ga*255)
         Ba = math.ceil(Ba*255)
        if Ra == oldR and Ga == oldG and Ba == oldB then
             SetPixel(buf,  n[1], n[2], fillR, fillG, fillB)
             Q:Push({n[1]-1,n[2]})
             Q:Push({n[1]+1,n[2]})
             Q:Push({n[1],  n[2]-1})
             Q:Push({n[1],  n[2]+1})
         end
     end
end
 
 --funcao BoundaryFill
function BoundaryFill(buf, x, y, borderR, borderG, borderB, fillR, fillG, fillB)
     local Q = Stack
     Q:Push({x,y})
     while Q:Empty() do
          local n = Q:Pop()
          if n == nil then
             return
          end
          local Ra, Ga, Ba = GetPixel(buf, n[1], n[2])
          --Ra = math.ceil(Ra*255)
          --Ga = math.ceil(Ga*255)
          --Ba = math.ceil(Ba*255)
         if (Ra ~= borderR or Ga ~= borderG or Ba ~= borderB) and (Ra ~= fillR or Ga ~= fillG or Ba ~= fillB) then
              SetPixel(buf,  n[1], n[2], fillR, fillG, fillB)
              Q:Push({n[1]-1,n[2]})
              Q:Push({n[1]+1,n[2]})
              Q:Push({n[1],  n[2]-1})
              Q:Push({n[1],  n[2]+1})
          end
      end
end
--------------------------------------------------------------------------------
--funcoes poligono
function CriaPoligono()
    return {}
end

function InserePonto(pol, ponto)
    table.insert(pol, ponto)
end

function DesenhaPoligono(buf, pol, r, g, b)
    local x = pol[1][1]
    local y = pol[1][2]
    
    for i = 2, #pol, 1 do
        DDA(buf, x, y, pol[i][1], pol[i][2], r, g, b)
        x = pol[i][1]
        y = pol[i][2]
    end
    DDA(buf, x, y, pol[1][1], pol[1][2], r, g, b)
end


function Intersecao(scan, seg)
    local xi = seg[1][1]
    local yi = seg[1][2]
    local xf = seg[2][1]
    local yf = seg[2][2]

    --segmento horizontal, sem intersecao
    if(yi == yf) then
        return -1
    end

    --troca para garantir ponto inicial em cima
    if yi > yf then
        local aux = xi
        xi = xf
        xf = aux
        ---------
        aux = yi
        yi  = yf
        yf = aux
    end
    --calcula o t
    local t = (scan - yi)/(yf - yi)

    --calcula x
    if t > 0 and t <= 1 then
        return math.ceil(xi + t*(xf - xi))
    end

    --sem Intersecao
    return -1
end

function GetYmin(tab)
    local min = tab[1][2]
    for i = 1, #tab, 1 do
        if tab[i][2] < min then
            min = tab[i][2]
        end
    end
    return min
end

function GetYmax(tab)
    local max = tab[1][2]
    for i = 1, #tab, 1 do
        if tab[i][2] > max then
            max = tab[i][2]
        end
    end
    return max
end

function ScanLine(buf, pol, r, g, b)

    local ymin = GetYmin(pol)--ok
    local ymax = GetYmax(pol)--ok

    for y = ymin, ymax do
        local i = {}
        local pix = pol[1][1]
        local piy = pol[1][2]
        for p = 2, #pol do
            local pfx = pol[p][1]
            local pfy = pol[p][2]
            
            local seg = {{pix, piy},{pfx,pfy}}
            local xi = Intersecao(y,seg)

            if xi >=0 then
                table.insert(i, xi)
            end
            pix = pfx
            piy = pfy
        end
        local pfx = pol[1][1]
        local pfy = pol[1][2]
        local seg = {{pix, piy},{pfx,pfy}}
        local xi = Intersecao(y,seg)

        if xi >=0 then
            table.insert(i, xi)
        end
        ------------------------------
        for k = 1, #i, 2 do
            for pixel = i[k], i[k+1], 1 do
                SetPixel(buf, pixel, y, 255,255,255)
            end
        end
    end
end
