
-- Considere uma turma de 50 alunos.
-- Cada aluno possui duas notas.




media: Aluno -> Float

nome: Aluno -> String


--List.map: (a->b) -> (List a) -> (List b)

--List.filter: (a->Bool) -> (List a) -> (List a)

--List.foldl : (a->b->b) -> b -> List a -> b
  -- reduz uma lista de a's para um valor do tipo b
        -- usa um valor inicial do tipo b
            -- recebe um elemento da lista de a
            -- recebe o atual valor acumulado
            -- retorna um novo valor acumulado


turma: Turma
turma = [ ("Joao",7,4), ("Maria",10,8), ("Igor",10,10), ("Deborah",5,0) ]   -- 50 alunos


medias: List Float
medias = List.map media turma
  
-- b) LISTA COM OS NOMES DOS ALUNOS DE "turma" APROVADOS (["Maria", ...])

mediaAprovado: Aluno -> Bool
mediaAprovado (nm,n1,n2) = ((n1+n2)/2) >= 7

aprovados: List String
aprovados = List.map nome (List.filter mediaAprovado turma)

--total: Float
--total = ...


-- main = text (toString medias)

main = text (toString aprovados)
