function love.load ()

	math.randomseed(os.time())

	--VARIABLES AND CONSTANTS
	
	backgroundSong = love.audio.newSource('maka_afora.mp3')
	love.audio.play(backgroundSong)
	love.graphics.setMode(800, 600, true, true)
	jogo = false
	opcoes = false
	timer_pirulito = 10000
	timer_manaBar = 2000
	manaFull = false
	especial = false
	tempo_explosao = 0
	gameOver = false
	angle = 0
	init = false
	success = false
	hallOfFame = false
	bonusVelocidade = 1
	muteStatus = false
	masterVolume = 0.5
	HOF = love.filesystem.read('HallOfFame.txt')
	
	--OBJECTS
		
	formiga = 
	{
		img = love.graphics.newImage('a.png'),
		x = 200,
		y = 200,
		w = 97,
		h = 63,
		vx = 0,
		vy = 0
	}
	
	pirulito =
	{
		img = love.graphics.newImage('pirulito.png'),
		x = 1500,
		y = (os.time()%6)*100 ,
		w = 70,
		h = 70,
		vx = 370,
		vy = 0
	}
	
	bala =
	{
		img = love.graphics.newImage('bala.png'),
		x = 2000,
		y = (os.time()%6)*100 ,
		w = 90,
		h = 89,
		vx = 480,
		vy = 0
	}
	
	simbolo_chazit =
	{
		img = love.graphics.newImage('chazit.png'),
		x = 50,
		y = 50,
		vx = 0,
		vy = 0
	}
	
	chazit_medalha = 
	{
		img = love.graphics.newImage('chazit_bola.png'),
		x = 5000,
		y = 400,
		w = 68,
		h = 68,
		vx = 520,
		vy = 0
	}
	
	bomba =
	{
		img = love.graphics.newImage('bomba.png'),
		x = formiga.x,
	    y = -2000,
		w = 48,
		h = 48,
		vx = 0,
		vy = 350
	}
	
	explosao = 
	{
		img = love.graphics.newImage('Explosion.png'),
		x = formiga.x,
		y = formiga.y,
		w = 99,
		h = 114,
		vx = 0,
		vy = 0
	}
		
	player =
	{
		life = 100,
		mana = 0,
		pontos = 0,
		nome = "ian"
	}
	
	estrela = 
	{
		img = love.graphics.newImage('estrela.png'),
		x = 0,
		y = 0,
		w = 35,
		h = 30,
		vx = 0,
		vy = 0
	}
	
	coracao = 
	{
		img = love.graphics.newImage('coracao.png'),
		x = -1000,
		y = 340,
		w = 50,
		h = 45,
		vx = 400,
		vy = 0
	}
	
	fundo_inicial =
	{
		img = love.graphics.newImage('tela_inicial.png'),
		x = 0,
		y = 0
	}
	
	mouse = 
	{
		img = nil,
		x = 0,
		y = 0,
		w = 5,
		h = 5
	}
	
	retangulo_jogar =
	{
		img = nil,
		x = 90,
		y = 260,
		w = 200,
		h = 100
	}
	
	retangulo_opcoes =
	{
		img = nil,
		x = 300,
		y = 300,
		w = 100,
		h= 50
	}
	
	retangulo_hallOfFame = 
	{
		img = nil,
		x = 500,
		y = 300,
		w = 100,
		h = 50
	}
	
	fullscreenON =
	{
		img = nil,
		status = true,
		x = 500,
		y = 350,
		w = 30,
		h = 30
	}
	
	fullscreenOFF = 
	{
		img = nil,
		status = false,
		x = 500,
		y = 430,
		w = 35,
		h = 30
	}
	
	increaseVolume = 
	{
		x = 150,
		y = 300,
		w = 50,
		h = 50
	}
	
	decreaseVolume = 
	{
		x = 150,
		y = 400,
		w = 50,
		h = 50
	}
	
	mutePosition = 
	{
		x = 720,
		y = 520,
		w = 60,
		h = 60
	}
	
	fundo_opcoes = 
	{
		x = 0,
		y = 0,
		img = love.graphics.newImage('fundo_opcoes_fullscreen.png')
	}
	
	drawingTable =
	{
		simbolo_chazit, formiga, pirulito, bala, chazit_medalha, bomba, coracao
	}
	
	
	fundo = love.graphics.newImage('fundo.jpg')
	muteImg = love.graphics.newImage('mute.png')
	unmuteImg = love.graphics.newImage('unmute.png')
	
end

function love.update (dt) 
	
	
	
	if muteStatus == true then
		love.audio.setVolume(0)
	end

	if muteStatus == false then
		love.audio.setVolume(masterVolume)
	end
	
	if jogo == true then
		love.mouse.setVisible(false)
		if init == false then
			pirulito.x = 1500
			chazit_medalha.x = 5000
			bala.x = 2000
			bomba.y = -2000
			init = true
		end
	end
	
	--STATUS DO JOGADOR
	if player.life <= 0 then
		gameOver = true
	end
	if player.mana > 100 then
		player.mana = 100
	end
	if player.mana == 100 then
		manaFull = true
	end
	if player.life > 100 then
		player.life = 100
	end
	
	if especial == true then
		if beleza == true then
			drawingTable [#drawingTable + 1] = estrela
			coracao.vx = 400
			coracao.x = 1500
			bonusVelocidade = 1.5
			beleza = false
		end
		formiga.img = love.graphics.newImage('formiga_especial.png')
		manaFull = false
		player.mana = player.mana - 7*dt
		chazit_medalha.x = 20000
	end
		
		
	if player.mana < 0 then
		player.mana = 0
		especial = false
		drawable_remove(estrela)
		chazit_medalha.x = 1500
		bonusVelocidade = 1
		formiga.img = love.graphics.newImage('a.png')
	end
		
	
	--TEMPO PARA O PIRULITO APARECER
	timer_pirulito = timer_pirulito - dt
	if timer_pirulito <= 0 then
		timer_pirulito = 10000
		drawingTable [#drawingTable + 1] = pirulito
	end
	
	--Doces se mexendo
	for i, object in ipairs(drawingTable) do
		object.x = object.x - object.vx*dt
	end
	
	--Bomba caindo
	for i, object in ipairs(drawingTable) do
		object.y = object.y + object.vy*dt
	end
	
	
	-- KEYS
	if love.keyboard.isDown ('right') then
		formiga.x = formiga.x + 275*dt*bonusVelocidade
		explosao.x = formiga.x - 45
		estrela.x = formiga.x
	elseif love.keyboard.isDown ('left') then
		formiga.x = formiga.x - 275*dt*bonusVelocidade
		explosao.x = formiga.x - 45
		estrela.x = formiga.x
	end
	if love.keyboard.isDown ('up') then
		formiga.y = formiga.y - 275*dt*bonusVelocidade
		explosao.y = formiga.y - 45
		estrela.y = formiga.y
	elseif love.keyboard.isDown ('down') then
		formiga.y = formiga.y + 275*dt*bonusVelocidade
		explosao.y = formiga.y - 45
		estrela.y = formiga.y
	end
	
	
	--Limites
	if formiga.x < 0 then
		formiga.x = 0
	end
	if formiga.x > (love.graphics.getWidth() - 97) then
		formiga.x = (love.graphics.getWidth() - 97)
	end
	if formiga.y < 0 then
		formiga.y = 0
	end
	if formiga.y > (love.graphics.getHeight() - 63) then
		formiga.y = (love.graphics.getHeight() -63)
	end
	
	if pirulito.x < (0 - pirulito.w) then
		pirulito.x = 850
		pirulito.y = (os.time()%6)*100
	end
	
	if bala.y > (love.graphics.getHeight() - 90) then
		bala.y = love.graphics.getHeight() - 90
	end
	
	if bala.y < 0 then
		bala.y = 0
	end
	
	if bala.x < (0 - bala.w) then
		bala.x = 900
		if formiga.y < 100 then
			bala.y = (os.time()%6)*100 + formiga.y
		elseif formiga.y > 500 then
			bala.y = (os.time()%6)*100 - formiga.y
		else
			bala.y = 300 + (formiga.y)/10
		end
	end
	
	if chazit_medalha.x < (0 - chazit_medalha.w) then
		chazit_medalha.x = 1500
		chazit_medalha.y = ((os.time()%6)*100)
	end
	
	if bomba.y > (600 + bomba.h) then
		bomba.x = formiga.x
		bomba.y = -1000
	end
	
	if coracao.y < 0 then
		coracao.y = 0
	end
	
	if coracao.x < (0 - coracao.w) then
		if especial == true then
			coracao.x = 3000
			coracao.y = ((os.time()%6)*100)
		elseif especial == false then
			coracao.x = -1000
		end
	end

	if jogo == true then
	
	
	--COLISAO ENTRE FORMIGA E PIRULITO
	if collision(formiga, pirulito) then
		--drawable_remove(pirulito)
		pirulito.x = 860
		pirulito.y = (os.time()%6)*100
		player.pontos = player.pontos + 25
	end
	

    --COLISAO ENTRE FORMIGA E BALA
	if collision(formiga, bala) then
		--drawable_remove(bala)
		bala.x = 900
		if formiga.y < 100 then
			bala.y = (os.time()%6)*100 + formiga.y
		elseif formiga.y > 500 then
			bala.y = (os.time()%6)*100 - formiga.y
		else
			bala.y = (os.time()%6) + (formiga.y)/10
		end
		player.pontos = player.pontos + 50
	end
	
	
	--COLISAO ENTRE FORMIGA E MEDALHA
	if collision(formiga, chazit_medalha) then
		--drawable_remove(chazit_medalha)
		chazit_medalha.x = 6000
		if ((os.time()%6)*100) < 200 then
			chazit_medalha.y = ((os.time()%6)*100) + 200
		end
		if ((os.time()%6)*100) > 500 then
			chazit_medalha.y = ((os.time()%6)*100) - 200
		end
		if especial == true then
			chazit_medalha.x = 99999
		end
			player.mana = player.mana + 20
	end
	
	
	--COLISAO ENTRE FORMIGA E BOMBA
		if collision(formiga, bomba) then
			bomba.x = (os.time()%8)*100
			bomba.y = -600
			player.life = player.life - 20
			explosao.x = formiga.x
			explosao.y = formiga.y
			drawingTable [#drawingTable + 1] = explosao
			tempo_explosao = 100
		end
		
		if collision(formiga, coracao) then
			if especial == true then
				coracao.x = 3000
				coracao.y = (os.time()%6)*100
			elseif especial == false then
				coracao.x = -1000
				coracao.vx = 0
			end
			player.life = player.life + 10
		end
	end
	if tempo_explosao > 0 then
			tempo_explosao = tempo_explosao -300*dt
	end
	if tempo_explosao <= 0 then
			drawable_remove(explosao)
	end
	
	timer_manaBar = timer_manaBar - 1500*dt
	if timer_manaBar <= -2000 then
		timer_manaBar = 2000
	end
		
	angle = angle + dt
	
	estrela.x = formiga.x + 20 + math.sin(angle*3.14)*13
	estrela.y = formiga.y + 20 + math.sin(angle*3.14)*13 
	
	
	mouse.x = love.mouse.getX()
	mouse.y = love.mouse.getY()
	
	if jogo == false then
		if love.mouse.isDown('l') then
			if collision(mouse, retangulo_jogar) and opcoes == false and hallOfFame == false then
				jogo = true
			end
			if collision(mouse, retangulo_opcoes) and jogo == false and hallOfFame == false then
				opcoes = true
			end
			if collision(mouse, retangulo_hallOfFame) and jogo == false and hallOfFame == false then
				hallOfFame = true
			end
		end
	end
	
	if opcoes == true then
		if love.mouse.isDown('l') then
			if collision(mouse, increaseVolume) then
				masterVolume = masterVolume + 0.001
				if masterVolume >= 1 then
					masterVolume = 1
				end
			end
			if collision(mouse, decreaseVolume) then
				masterVolume = masterVolume - 0.001
				if masterVolume <= 0 then
					masterVolume = 0
				end
			end
			if collision(mouse, fullscreenON) and fullscreenON.status == false then
				fullscreenON.status = true
				fundo_opcoes.img = love.graphics.newImage('fundo_opcoes_fullscreen.png')
				fullscreenOFF.status = false
			end
			if collision(mouse, fullscreenOFF) and fullscreenOFF.status == false then
				fullscreenOFF.status = true
				fundo_opcoes.img = love.graphics.newImage('fundo_opcoes_window.png')
				fullscreenON.status = false
			end
		end
	end
	
	if love.mouse.isDown('l') and collision (mouse, mutePosition) then
		if muteStatus == false then
			muteStatus = true
		elseif muteStatus == true then
			muteStatus = false
		end
	end
	
	if jogo == false then
		if love.mouse.isDown('l') then
			if collision(mouse, retangulo_jogar) then
				jogo = true
			end
		end
	end
	
end



function love.keypressed (key)
		
	if key == 'escape' then
		love.event.push("quit")
	elseif key == ' ' then
		jumpUp = true 
	end
	
	if key == ' ' then
		if manaFull == true then
			especial = true
			beleza = true
		end
	end
		
	
end



function collision (o1, o2)
	
	x1 = o1.x + o1.w
	x2 = o2.x + o2.w
	y1 = o1.y + o1.h
	y2 = o2.y + o2.h
	
	if x1 < o2.x then
		return false
	elseif o1.x > x2 then
		return false
	elseif y1 < o2.y then
		return false
	elseif o1.y > y2 then
		return false
	else
		return true
	end
end


function drawable_remove(obj1)
	
	for i, obj2 in ipairs (drawingTable) do
		if obj1 == obj2 then
			table.remove(drawingTable, i)
			return
		end
	end
end


function love.draw()

	if jogo == true then
			
		if gameOver == false then
			love.graphics.draw(fundo, 0, 0)
			--love.graphics.setColor(0,0,0)
			love.graphics.print(player.pontos, 105, 225, 0, 3, 3)
		
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("line", 500, 50, 150, 20)
			love.graphics.rectangle("line", 500, 80, 150, 20)
			love.graphics.setColor(178, 034, 034)
			love.graphics.rectangle("fill", 500, 50, player.life*1.5, 20)
			if manaFull == false then
				love.graphics.setColor(255,165,0)
				love.graphics.rectangle("fill", 500, 80, player.mana*1.5, 20)
				love.graphics.setColor(255,255,255)
			end
			if manaFull == true then
				if timer_manaBar < 0 then
					love.graphics.setColor(255,165,0)
					love.graphics.rectangle("fill", 500, 80, 150, 20)
					love.graphics.setColor(255,255,255)
				end
				if timer_manaBar >= 0 then
					love.graphics.setColor(255, 127, 036)
					love.graphics.rectangle("fill", 500, 80, 150, 20)
					love.graphics.setColor(255, 255, 255)
				end
			end
			
			love.graphics.setColor(0,0,0)
				love.graphics.print("HP", 470, 50, 0, 1.3, 1.3)
				love.graphics.print("MP", 470, 80, 0, 1.3, 1.3)
			love.graphics.setColor(255,255,255)
			
			
		if manaFull == true then
			love.graphics.setColor(0, 0, 0)
			love.graphics.print("APERTE ESPACO", 505, 80, 0, 1.3, 1.3)
			love.graphics.setColor(255, 255, 255)
		end
			
			for i, object in ipairs(drawingTable) do
				if object.img == 'simbolo_chazit.png' then
					love.graphics.setColor( 255, 255, 255, 120 )
					love.graphics.draw(object.img, object.x, object.y)
					love.graphics.setColor(255, 255, 255, 255)
				else
					love.graphics.draw(object.img, object.x, object.y)
				end
			end
		elseif gameOver == true then
			success = love.filesystem.write('HallOfFame.txt', HOF .. "\n" .. player.nome ..
			" - " .. player.pontos )
			love.graphics.setColor(255, 255, 255)
			love.graphics.print("GAME OVER", 285, 200, 0, 3, 3)
			love.graphics.print("pressione 'esc' para sair",  270, 300, 0, 1.6, 1.6)
			love.graphics.setColor(0, 0, 0)
		end
	elseif jogo == false then
		love.graphics.draw(fundo_inicial.img, fundo_inicial.x, fundo_inicial.y)
		if muteStatus == false then
				love.graphics.draw(muteImg, 720, 520)
		elseif muteStatus == true then
				love.graphics.draw(unmuteImg, 720, 520)
		end
		if opcoes == false and hallOfFame == false then
			love.graphics.draw(fundo_inicial.img, fundo_inicial.x, fundo_inicial.y)
		elseif opcoes == true then
			love.graphics.draw(fundo_opcoes.img, fundo_opcoes.x, fundo_opcoes.y)
			love.graphics.print((masterVolume*10), 175, 365, 0, 1.5, 1.6)
		end
		if hallOfFame ==  true then
			love.graphics.setColor(255, 255, 255)
			love.graphics.print(HOF, 200, 200, 0, 1.2, 1.2)
		end
	end
end