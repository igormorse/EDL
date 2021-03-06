screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

-- Tamanho padrão dos Blocos.
default_block_size = 20

-- Pontuação máxima.
high_score = 0

-- Flag de Gameover.
gameover = false

--[[  Tarefa 05

  Nome:                 Variavel "gameover"
  Propriedade:          Endereço
  Binding Time:         Compilação
  Explicação:           Por ser uma variavel global, sua amarração será feita em tempo de compilação.

]]

-- Flag de Debug.
debug = false

-- Variavel splashscreen
local splash
local o_ten_one = require "o-ten-one"

-- Flag de Carregamento
loading = true

function love.load ()

  --[[  Tarefa 06

      {"lighten",3}
      Tipo: Tupla

  ]]
  -- Carregamento da Lib de splashscreen
  splash = o_ten_one({"lighten",3})
  splash.onDone = function() loading = false end

  -- Título do Jogo.
  love.window.setTitle("Snake Game")

  --[[  Tarefa 06

      "static" ou "stream"
      Tipo: Enumeração

  ]]
  -- Sons do Jogo.
  sound_eating =  love.audio.newSource("eating.wav", "static")
  sound_gameover = love.audio.newSource("gameover.wav", "static")

  -- Inicializa a Cor do Cenário
  love.graphics.setBackgroundColor(255,255,255)

  -- Inicializa a Cor das Linhas de Demarcação do Cenário.
  love.graphics.setColor(0,0, 0)

  --[[  Tarefa 06

      scenarioLimits = {}
      Tipo: Array

  ]]
  -- Define os limites do cenário na tela. ( Xi , Yi )
  scenarioLimits = {
    10,20,
    10,screenHeight-10,
    screenWidth-10,screenHeight-10,
    screenWidth-10,20,
    10,20
  }

  --[[ Tarefa 07

    Array: scenarioObstacles

    Escopo: blocks é um array global de blocos.

    Tempo de Vida: Desde a alocação até o jogo seja reiniciado fazendo com que o load carregue novamente.

    Alocação: Quando jogo é iniciado, é alocado inicialmente 1 bloco junto com o "respawn" da "comida" e a cada vez que a "snake" come a "comida" mais um bloco é adicionado.

    Desalocação: A cada um certo período de tempo é removido um bloco dessa coleção.

  ]]
scenarioObstacles = {}

  --[[  Tarefa 06

      player = {pos = {} ,...}
      Tipo: Registro

  ]]
  -- Iniciliza o Jogador.
  player = {
    pos = {
      current = {
        x = screenWidth/2,
        y = screenHeight/2
      },
      previous = {
        x = nil,
        y = nil
      }
    },
    direction = {
      x = 1,
      y = 0,
    },
    body = {
      size = 0,
      speed = 1400,
      gap = 1,

      blocks = {}
    }
  }

  --[[ Tarefa 08
      Inicialização da Comida.
  ]]
  food = newFood()

  -- food = {
  --   pos = {
  --     x = nil,
  --     y = nil
  --   },
  --   isAlive = false
  -- }

  print("Criei Corpo do Player! : " .. tostring(player.body.size) .. "    x: " .. tostring(player.pos.current.x) .. "    y: " .. tostring(player.pos.current.y))

    -- Inicializa dois blocos ao Jogador e Inicializa comida no cenário.
    for i = 1,4 do

      initialPosX = player.pos.current.x - ( ( default_block_size + player.body.gap ) * ( player.body.size + 1 ) ) * player.direction.x

      new_block = playerAddBlock(initialPosX,player.pos.current.y)

      table.insert(player.body.blocks, new_block)
    end

    --[[ Tarefa 08
        "Respawn" da Comida.
    ]]
    -- Inicializa a comida no cenário.
    -- respawnPlayerFood()
    food.respawn()

    --[[ Tarefa 05

      Nome:                 Variavel "accumulator.limit"
      Propriedade:          Valor
      Binding Time:         Compilação
      Explicação:           Em tempo de compilação será feita a atribuição deste valor, limit é fixo e não possui alterações durante a execução do progarma.

    ]]
    -- Inicializa o limitador de tickRate.
    accumulator = {
      current = 0,
      limit= 0.1
    }

  end

  --[[ Tarefa 08

    Implementação de Closure e a co-rotina que movimenta a comida em forma retangular.

  ]]
  function newFood()

    local x
    local y
    local speed = { x = 80, y = 100 }
    local isAlive = false

    local me; me = {

      move = function (dx,dy)
             x = x + dx
             y = y + dy
      end,
      respawn = function()
        x = love.math.random(20, screenWidth - 30)
        y = love.math.random(20, screenHeight - 30)
        isAlive = true

        --[[ Tarefa 07

          Criação do bloco de Obstáculos a cada vez que a comida renasce no jogo.
          Ou seja no ínicio do jogo será inicializado um bloco de obstáculo e toda vez que a Snake comer um novo bloco aparecerá no jogo.

        ]]
        table.insert(scenarioObstacles,createBlock(x,y))
      end,

      colided = function(player)
        return ( player.pos.current.x + default_block_size >= x ) and ( player.pos.current.x <= x + default_block_size) and ( player.pos.current.y + default_block_size >= y) and ( player.pos.current.y <= y + default_block_size )
      end,

      getPos = function()
        return x,y
      end,

      getPosX = function()
        return x
      end,

      getPosY = function()
        return y
      end,

      getAlive = function()
        return isAlive
      end,
      moveIt = coroutine.create(function (dt)
            while (1==1) do
      				for i=1, 180 do
      					me.move( speed.x*dt, 0)
      					dt = coroutine.yield()
      				end
      				for i=1, 50 do
      					me.move( 0, speed.y*dt)
      					dt = coroutine.yield()
      				end
      				for i=1, 180 do
      					me.move( -speed.x*dt, 0)
      					dt = coroutine.yield()
      				end
      				for i=1, 50 do
      					me.move( 0, -speed.y*dt)
      					dt = coroutine.yield()
      				end
            end
        end),
    }

    return me

  end

  function love.keypressed (key)

    if key == 'left' or key == 'd' then
      if player.direction.x ~=1 and player.direction.y ~=0 then
        player.direction.x = -1
        player.direction.y = 0
      end
    elseif key == 'right' then
      if player.direction.x ~=-1 and player.direction.y ~=0 then
        player.direction.x = 1
        player.direction.y = 0
      end
    elseif key == 'up' then
      if player.direction.x ~= 0 and player.direction.y ~=1 then
        player.direction.x = 0
        player.direction.y = -1
      end
    elseif key == 'down' then
      if player.direction.x ~= 0 and player.direction.y ~=-1 then
        player.direction.y = 1
        player.direction.x = 0
      end
    elseif key == 'f' then
      playerAddBlock()
    elseif key == '2' then
      player.body.speed = player.body.speed + 50
    elseif key == '1' then
      player.body.speed = player.body.speed - 50
    elseif key == 'r' and gameover then
      gameover = false
      love.load()
    end
  end

  -- Adiciona um bloco ao Jogador.
  function playerAddBlock(x,y)

    -- Estrutura do Novo Bloco.
    new_block = createBlock(x,y)

    player.body.size = player.body.size + 1

    print("Criei Corpo no Player! : " .. tostring(player.body.size) .. "    x: " .. tostring(new_block.pos.x) .. "    y: " .. tostring(new_block.pos.y))

    return new_block

  end

  function createBlock(x,y)

    local new_block

    -- Estrutura do Novo Bloco.
    new_block = {
      pos = {
        x = x,
        y = y
      },
      accumulator = {
        current = 0,
        limit = 1
      }
    }

    return new_block

  end

  -- Atualiza a posição da Comida.
  -- DEPRECATED
  function respawnPlayerFood()

    food.pos.x = love.math.random(20, screenWidth - 30)
    food.pos.y = love.math.random(20, screenHeight - 30)

    food.isAlive = true

  end

  -- Ativa o modo gameOver no Jogo.
  function gameOver()

    if not gameover then
      love.audio.play( sound_gameover )
      gameover = true
      player_movement_speed = 0
      high_score = player.body.size
    end


  end

  -- Atualiza o placar do jogo.
  function updatescore()
    if(player.body.size > high_score) then
      high_score = player.body.size
    end
  end

  -- Jogador colidindo com as paredes.
  function playerWallCollision ()

    if player.pos.current.x <= 10 or player.pos.current.x >= screenWidth-10 - default_block_size  or player.pos.current.y <= 20  or player.pos.current.y >= screenHeight-10 -default_block_size then
      player.body.speed = 0
      gameOver()
    end
  end

  -- Jogador colidindo com algum outro bloco
  function blockCollision (player, block)
    return ( player.pos.current.x + default_block_size >= block.pos.x ) and ( player.pos.current.x <= block.pos.x + default_block_size) and ( player.pos.current.y + default_block_size >= block.pos.y) and ( player.pos.current.y <= block.pos.y + default_block_size )
  end

  --[[ Tarefa 05

    Nome:                 Variavel "block"
    Propriedade:          Endereço
    Binding Time:         Execução
    Explicação:           Como block é uma variável local da função blockCollision, então seu endereço só irá ser atribuido em tempo de execução.

  ]]

  --[[ Tarefa 05

    Nome:                 Palavra "and"
    Propriedade:          Semântica
    Binding Time:         Design da Linguagem
    Explicação:           A palavra and é uma palavra reservada do Lua, logo sua amarração foi feita em tempo de Design da Linguagem.

  ]]

  function love.update (dt)

    -- Splash Screen sendo executada
    if loading then
      splash:update(dt)
      return true
    end

    --[[ Tarefa 08
        Resume a Co-Rotina, permitindo que o jogo movimente de forma contínua retangular a comida sem parar o resto do jogo.
    ]]
    coroutine.resume(food.moveIt, dt)

    --[[ Tarefa 05

      Nome:                 Palavra "then"
      Propriedade:          Semântica
      Binding Time:         Design da Linguagem
      Explicação:           A palavra then é uma palavra reservada do Lua, logo sua amarração foi feita em tempo de Design da Linguagem.

    ]]

    -- Acumulador do dt.
    accumulator.current = accumulator.current + dt

    -- Limita o tickRate do jogo e verifica gameOver.
    if (accumulator.current >= accumulator.limit and gameover == false) then

      accumulator.current = accumulator.current-accumulator.limit;

      -- Guarda a posição antiga do jogador.
      player.pos.previous.x = player.pos.current.x
      player.pos.previous.y = player.pos.current.y

      -- Atualiza a posição atual do jogador.
      player.pos.current.x = player.pos.current.x + ( player.direction.x * player.body.speed * dt )
      player.pos.current.y = player.pos.current.y + ( player.direction.y * player.body.speed * dt )

      -- Verifica a colisão entre player e parede.
      playerWallCollision()

      -- Verifica a colisão entre player e seus blocos do corpo.
      for i,block in ipairs(player.body.blocks) do
        if (blockCollision(player,block) == true) then
          player.body.speed = 0
          gameOver()
        end
      end

      --[[  Tarefa 07

        Loop que verifica a colisão dos blocos de obstáculos com a Snake.

      ]]
      for i,block in ipairs(scenarioObstacles) do
        if (blockCollision(player,block) == true) then
          player.body.speed = 0
          gameOver()
        end

        --[[  Tarefa 07

          Realiza a remoção desses blocos a cada um certo período de tempo acumulado.

        ]]
        block.accumulator.current = block.accumulator.current + dt
        if (block.accumulator.current >= block.accumulator.limit) then
          table.remove(scenarioObstacles,i)
        end
      end

      -- Colisão entre player e comida.
      --if (blockCollision(player,food)) then
      if (food.colided(player)) then

        tail = playerAddBlock(player.pos.previous.x , player.pos.previous.y)

        love.audio.play( sound_eating )

        -- respawnPlayerFood()
        food.respawn()

      else

        tail = table.remove(player.body.blocks,player.body.size)

        tail.pos.x = player.pos.previous.x
        tail.pos.y = player.pos.previous.y
      end

      --[[ Tarefa 05

        Nome:                 Variavel "tail"
        Propriedade:          Valor
        Binding Time:         Execução
        Explicação:           Como não sabemos qual vai ser o "rabo" da cobra, este valor só poderá ser atribuido em tempo de execução.

      ]]

      -- Funcionamento do FILO ( First In Last Out )
      table.insert(player.body.blocks,1,tail)

      -- Atualiza a pontuação.
      updatescore()

    end
  end

  -- Desenha o Jogador e seus blocos.
  function drawPlayer()

    love.graphics.setColor(255, 0, 0, 180)

    -- Desenho do Jogador. ( Cabeça )
    love.graphics.rectangle( "fill", player.pos.current.x, player.pos.current.y, default_block_size, default_block_size )

    love.graphics.setColor(0, 0, 0, 255)

    -- Desenho do Corpo.
    for i,block in ipairs(player.body.blocks) do
      love.graphics.rectangle( "fill", block.pos.x, block.pos.y, default_block_size, default_block_size )
    end

    --Desenho do status
    love.graphics.print("Body Size " .. tostring(player.body.size) , 5, 5)
    love.graphics.print("Speed " .. tostring(player.body.speed) , 150, 5)
    love.graphics.print("High Score " .. tostring(high_score) , screenWidth-150, 5)

    -- Mostra a posição do Jogador.
    if (debug == true) then
      love.graphics.print("x " .. tostring(player.pos.current.x) , screenWidth-150, 20)
      love.graphics.print("y " .. tostring(player.pos.current.y) , screenWidth-150, 30)
    end
  end

  function love.draw()

    -- Verifica se não é a SplashScreen que tem que desenhar.
    if not loading then
      -- Desenho do Cenário.
      love.graphics.line(scenarioLimits)

      -- Desenha o Jogador.
      drawPlayer()

      -- Desenho da Comida.
      if (food.getAlive()) then
        love.graphics.setColor(0,0,255)
        love.graphics.rectangle( "fill", food.getPosX(), food.getPosY(), default_block_size, default_block_size )
      end

      love.graphics.setColor(255,153,0)
      for i,block in ipairs(scenarioObstacles) do
        love.graphics.rectangle("fill", block.pos.x, block.pos.y, default_block_size, default_block_size)
      end

      love.graphics.setColor(0,0,255)
      if(gameover) then
        love.graphics.print("Press R to restart game", screenWidth/2 - 70, screenHeight/2)
      end
    else
      -- Desenho da splashscreen
      splash:draw()
    end

  end
