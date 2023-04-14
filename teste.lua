local t = {{250,20},{350,250}}

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
    print(t)
    --calcula x
    if t > 0 and t <= 1 then
        local x = (xi + t*(xf - xi))
        return math.ceil(x)
    end

    --sem Intersecao
    return -1
end

print(Intersecao(22, t))
--