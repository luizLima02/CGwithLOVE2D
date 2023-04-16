--funcoes de vetores
--multiplica um vetor por um escalar
function VetorEscalar(c, V)
    local W = {}
    for i = 1, #V, 1 do
        W[i] = V[i] * c
    end
    return W
end

--soma dois vetores de mesmo tamanho
function SumVetor(U, V)
    if #U ~= #V then
        return
    end
    local W = {}
    for i = 1, #V, 1 do
        W[i] = V[i] + U[i]
    end
    return W
end

--Subtrai dois Vetores (V - U) 
function SubVetor(V, U)
    if #U ~= #V then
        return
    end
    local W = {}
    for i = 1, #V, 1 do
        W[i] = V[i] - U[i]
    end
    return W
end
----------------------------------------
--funcoes de matrizes
function CreateMatrix(row, col)
    local M = {}
    for i = 1, row, 1 do
        M[i] = {}
        for j = 1, col, 1 do
            M[i][j] = 0
        end
    end
    return M
end

--ok
function LinhaColuna(A, B, i, j)
    local soma = 0
    for k = 1, #A[i], 1 do
        soma = soma + (A[i][k] * B[k][j])
    end
    return soma
end

--ok
--[[
    o algoritmo supoe a entrada formatada corretamente pelo usuario
]]
function ProdMatrix(A, B)
    if #A ~= #B[1] then
        return
    end
    local C = CreateMatrix(#A, #B[1])
    for i = 1, #A, 1 do
        for j = 1, #B[1], 1 do
            C[i][j] = LinhaColuna(A, B, i, j)
        end
    end
    return C
end 

--Soma 2 matrizes de mesmo tamanho e retorna
function SumMatrix(A, B)
    if #A ~= #B then
        return
    end
    local C = CreateMatrix(#A, #A[1])
    for i = 1, #A, 1 do
        for j = 1, #A[i], 1 do
            C[i][j] = A[i][j] + B[i][j]
        end
    end
    return C
end

--Soma 2 matrizes de mesmo tamanho e retorna (A - B)
function SubMatrix(A, B)
    if #A ~= #B then
        return
    end
    local C = CreateMatrix(#A, #A[1])
    for i = 1, #A, 1 do
        for j = 1, #A[i], 1 do
            C[i][j] = A[i][j] - B[i][j]
        end
    end
    return C
end

--multiplica uma matriz por um escalar
function MatEscalar(c, A)
    local C = CreateMatrix(#A, #A[1])
    for i = 1, #A, 1 do
        for j = 1, #A[i], 1 do
            C[i][j] = A[i][j] * c
        end
    end
end

function TransMatriz(A)
    local C = CreateMatrix(#A[1], #A)
    for i = 1, #C, 1 do
        for j = 1, #C[i], 1 do
            C[i][j] = A[j][i]
        end
    end
end
----------------------------------
--funcoes de matrizes e vetores
--multiplica um Vetor por Uma Matriz
function ProdMatrixVet(A, B)
    local Bl = {B}
    if #A ~= #Bl[1] then
        return
    end
    local C = CreateMatrix(#A, #Bl[1])
    for i = 1, #A, 1 do
        for j = 1, #Bl[1], 1 do
            C[i][j] = LinhaColuna(A, Bl, i, j)
        end
    end
    return C
end
