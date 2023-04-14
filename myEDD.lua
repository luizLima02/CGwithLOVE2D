--minha implementacao pilha
Pilha = function ()
    return{
        stack = {},
        Push = function (self, elem)
            table.insert(self.stack, elem)
        end,
        Consultar = function(self)
            local elem
            if #self.stack ~= 0 then
                elem = self.stack[#self.stack]
                return elem
            else
                return nil
            end
        end,
        Pop = function (self)
            local elem
            if #self.stack ~= 0 then
                elem = self.stack[#self.stack]
                table.remove(self.stack, #self.stack)
                return elem
            else
                return nil
            end
        end,
        --retorna true se a pilha nao estiver vazia
        Empty = function (self)
            if #self.stack == 0 then
                return false
            else
                return true
            end
        end,
        Delete = function (self)
            self.stack = nil
            collectgarbage()
        end
    }
end

--minha implementacao de Conjunto TODO
Conjunto = function ()
    return{
        conj = {},
        contem = function (self, e)
            local elem
            for i = 1, #self.conj, 1 do
                elem = self.conj[i]
                if elem == e then
                    return true
                end
            end
            return false
        end,
        inserir = function (self, e)
            if self.contem(self, e) == false then
                table.insert(self.conj, e)
            end
        end
    }
end

--TODO
Lista = function ()
    
end

--TODO
Heap = function ()
    
end

--TODO
Dicio = function ()
    
end