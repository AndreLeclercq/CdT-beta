# Crédits #
# Script par LEIFER KOPF // leifer.kopf@gmail.com
# Scénario par VINCENT CORLAIX  // vcorlaix@nootilus.com
# Disclaimer : L'ensemble du contenu de ce document est la propriété de GalaaDScript, il ne peut être utilisé, même partiellement sans accord préalable de GalaaDScript (Filliale du groupe AE-Com).
# version : 0.253

extends Control

# Variables
var save = {}
var currentDial = null
var timer = null
var time_delay = 1
var content = null
var dial = []
var size = null
var scenarioFile = null
var version = null
var stateSave = null
var data = null
var dataDial = null
var dataRep = null
var firstDial = null
var currentRep = null
var currentTime = null
var vscroll = 50
var saveDial = []
var saveRep = []
var saveTime = []
var labelH = null
var hourIG = "0"
var minuteIG = "0"
var secondIG = "0"
var saveNextTime = []
var dataNextTime = null
var unixTime = OS.get_unix_time()
var timeIG = null
var calcultime = 0
var timezone = 0
var realtime = 0
var buttonPressed = null
var statusText = null
var status = 0
var statusNext = 0
var visible = 1
var sound = 0
var triggerName = null
var triggerVol = 0
var lastRep = false
var bg_sound = null
var bg_sound_vol = null
var actualContent = null
var Type = null
var Text = null
var Target = null
var ConfigTimer = null
var ConfigSoundTRG = null
var ConfigVolumeTRG = null
var ConfigSoundBKG = null
var ConfigVolumeBKG = null
var buttonName = null
var buttonText = []
var TargetPin = null
var buttonTarget = []
var origin = null
var labelNode = null
var imgTexture = null
var actualSound = null
var sampleMSG = null
var devMode = 0

############################### PREPARATION DU SCRIPT ###############################

# Ready
func _ready():

	print("Crédits")
	print("Script par LEIFER KOPF // leifer.kopf@gmail.com")
	print("Scénario par VINCENT CORLAIX  // vcorlaix@nootilus.com")
	print("Disclaimer : L'ensemble du contenu de ce document est la propriété de GalaaDScript, il ne peut être utilisé,	même partiellement sans accord préalable de GalaaDScript (Filliale du groupe AE-Com).")
	print("...................................................................................")
	print("#### LANCEMENT DU JEU ####")

	# Texte Popup Options
	get_node("Popup/VBox/Reset").set_text(str(LOAD.optionsText[0]))
	get_node("Popup/VBox/Retour").set_text(str(LOAD.optionsText[2]))
	get_node("Popup/VBox/Quitter").set_text(str(LOAD.optionsText[3]))

	# Initialisation du Timer
	print("Initialitation du Timer")
	timer = get_node("Timer")
	timer.set_wait_time(0.01)
	
	# Calcule time zone
	timezone = OS.get_datetime_from_unix_time(OS.get_unix_time()).hour
	realtime = OS.get_time().hour
	calcultime = realtime - timezone

	if LOAD.fileExists == true and LOAD.stateSave == true:
		# Ecran de chargement
		get_node("Loading").popup()
		get_node("Loading/Label").set_text(LOAD.gameText[7])
		# Réécriture de la Sauvegarde
		print("Réécriture de la sauvegarde")
		LOAD.vscroll = get_node("vbox/Mid/DialBox").get_size().height
		for i in range(LOAD.loadsave.dial.size()):
			LOAD.currentDial = LOAD.loadsave.dial[i]
			LOAD.currentRep = LOAD.loadsave.rep[i]
			LOAD.currentNextTime = LOAD.loadsave.nexttime[i]
			for item in LOAD.dial:
				if item.Properties.has("DisplayName") and item.Properties.DisplayName == LOAD.currentDial:
					if item.Type == "DialogueTemplate":
						last_dial()
						origin = 1
						Type = item.Type
						Text = item.Properties.Text
						Target = item.Properties.OutputPins[0].Connections[0].Target
						ConfigTimer = item.Template.Config.Timer

						# Vérification du status
						LOAD.time_delay = ConfigTimer
						status()
						if LOAD.currentNextTime <= OS.get_unix_time():
							LOAD.time_delay = 1
							status()
							if item.Template.Config.MessageSystem == false:
								# Ecrit l'heure
								print("Horodatage")
								LOAD.saveTime = LOAD.currentNextTime
								system_time()
								var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelTime")
								var label = labelbase.duplicate()
								label.set_name(str("LabelTime",LOAD.currentTime))
								get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
								label.show()
								print("Affiche l'heure")
								if devMode == 0:
									label.set_text(str(" - ",LOAD.timeIG))
								else:
									label.set_text(str(" - ",LOAD.timeIG," : ",LOAD.currentDial))
								label.set("visibility/opacity",1)
								var labelH = label.get_text()
								labelNode = "vbox/Mid/DialBox/VBoxMid/LabelDial"
							else:
								labelNode = "vbox/Mid/DialBox/VBoxMid/LabelSys"
							# Ecrit la ligne de dialogue
							print("Traitement du Dialogue")
							actualContent = Text
							actualContent = actualContent.split("\r\n\r\n")
							for sentence in actualContent:
								print("Création du label")
								var labelbase = get_node(labelNode)
								var label = labelbase.duplicate()
								print("Configuration du label")
								label.set_name(str("labelDial"))
								var labelbg = str("vbox/Mid/DialBox/VBoxMid/labelDial/LabelBG")
								print(labelbg)
								get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
								label.show()
								label.set_text(sentence)
								if item.Template.Config.MessageSystem == false:
							# Ajustement de la taille du label
									var labelsize = label.get_line_count()
									if labelsize == 1:
										label.set_size(Vector2(925,50))
										label.set("rect/min_size",Vector2(925,50))
										get_node(labelbg).set("transform/scale",Vector2(1,1))
									elif labelsize == 2:
										label.set_size(Vector2(925,110))
										label.set("rect/min_size",Vector2(925,110))
										get_node(labelbg).set("transform/scale",Vector2(1,2))
									elif labelsize == 3:
										label.set_size(Vector2(925,170))
										label.set("rect/min_size",Vector2(925,170))
										get_node(labelbg).set("transform/scale",Vector2(1,3))
									elif labelsize == 4:
										label.set_size(Vector2(925,230))
										label.set("rect/min_size",Vector2(925,230))
										get_node(labelbg).set("transform/scale",Vector2(1,4))
									elif labelsize == 5:
										label.set_size(Vector2(925,290))
										label.set("rect/min_size",Vector2(925,290))
										get_node(labelbg).set("transform/scale",Vector2(1,5))
							# Auto Scroll
								yield(get_tree(), "idle_frame")
								get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
								LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
								get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
								label.set("visibility/opacity",1)

					# Ecrit la ligne de réponse
					if item.Type == "ReponseTemplate":
						origin = 0
						TargetPin = item.Properties.OutputPins[LOAD.currentRep].Id
						buttonTarget.append(item.Properties.OutputPins[LOAD.currentRep].Connections[0].TargetPin)
						for caribou in LOAD.dial:
							if caribou.Properties.has("OutputPins") and caribou.Properties.OutputPins[0].has("Connections") and caribou.Properties.OutputPins[0].Connections[0].TargetPin == TargetPin:
								if caribou.Properties.Text == "":
									buttonText.append(caribou.Properties.MenuText)
								else:
									buttonText.append(caribou.Properties.Text)
								

						# Ecrit la ligne de Dialogue
						print("Création du label")
						var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelRep")
						var label = labelbase.duplicate()
						print("Configuration du label")
						label.set_name(str("label",buttonText[0]))
						get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
						label.show()
						print("Ecrit la ligne de dialogue : ",buttonText[0])
						label.set_text(str(buttonText[0]))
					# Ajustement de la taille du label
						var labelsize = label.get_line_count()
						print(str("Nombre de ligne :",labelsize))
						if labelsize == 1:
							label.set_size(Vector2(925,55))
							label.set("rect/min_size",Vector2(925,55))
						elif labelsize == 2:
							label.set_size(Vector2(925,110))
							label.set("rect/min_size",Vector2(925,110))
						elif labelsize == 3:
							label.set_size(Vector2(925,170))
							label.set("rect/min_size",Vector2(925,170))
						elif labelsize == 4:
							label.set_size(Vector2(925,230))
							label.set("rect/min_size",Vector2(925,230))
						elif labelsize == 5:
							label.set_size(Vector2(925,290))
							label.set("rect/min_size",Vector2(925,290))
						print(str("Taille du label :",label.get_size()))
					# Auto Scroll
						print("Scroll")
						yield(get_tree(), "idle_frame")
						get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
						LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
						get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
						label.set("visibility/opacity",1)
						buttonText = []
						buttonTarget = []
			print("Fin du chargement")
			print("Réécriture Dialogues dans le JSON")
			actualSound = load(str("res://snd/",LOAD.actualBGSound,".ogg"))
			get_node("SampleBKG").set_stream(actualSound)
			if LOAD.MusicButton == 1:
				get_node("SampleBKG").play(0)
		LOAD.tween = get_node("Tween")
		LOAD.targetNode = get_node("Loading")
		LOAD.tweenType = "visibility/opacity"
		LOAD.tweenStart = 1
		LOAD.tweenEnd = 0
		LOAD.tweenTime = 0.5
		LOAD.system_tween()
	
	soundOptions()

	if LOAD.fileExists == true and LOAD.currentNextTime <= OS.get_unix_time():
		find_next_target()
		LOAD.launch = 1
	

# Affichage du nom de l'interlocuteur
	print("Affichage du nom")
	get_node("vbox/Top/Name").add_text(str(LOAD.namePNJ))

# Affichage de la version de dev en JEU
	print("Affichage version en jeu")
	get_node("vbox/Top/version").set_text(str(LOAD.version))

	if LOAD.fileExists == false:
		start()
		
# Affichage de l'heure
	set_process(true)

# Process
func _process(delta):
	
	LOAD.saveTime = OS.get_unix_time()
	system_time()
	# Affichage de l'heure
	get_node("vbox/Top/clock").set_text(LOAD.timeIG)

	if LOAD.launch != 0 and LOAD.currentNextTime <= OS.get_unix_time():
		print("Fin du timer")
		LOAD.launch = 0
		start()
	
	if get_node("Loading").get("visibility/opacity") == 0:
		get_node("Loading").hide()
		get_node("Loading").set("visibility/opacity", 1)



############################### DEBUT DU SCRIPT ###############################
# Fonction ou reboucle le script quand il repart du début
# Start
func start():
	visible = 0
	print("Début du processus d'interpretation du JSON")

# Récupération des données
	for item in LOAD.dial:
		if item.Properties.has("DisplayName") and item.Properties.DisplayName == LOAD.currentDial and LOAD.launch == 0:
			if item.Type == "DialogueTemplate":
				Type = item.Type
				Text = item.Properties.Text
				Target = item.Properties.OutputPins[0].Connections[0].Target
				ConfigTimer = item.Template.Config.Timer
				ConfigSoundTRG = item.Template.Config.soundTRG
				ConfigVolumeTRG = item.Template.Config.volumeTRG
				ConfigSoundBKG = item.Template.Config.soundBKG
				ConfigVolumeBKG = item.Template.Config.volumeBKG
			
				# Vérification d'un trigger son
				if ConfigSoundTRG != "":
					triggerName = ConfigSoundTRG
					triggerVol = ConfigVolumeTRG
					trigger_sound()
				if ConfigSoundBKG != "":
					bg_sound = ConfigSoundBKG
					bg_sound_vol = ConfigVolumeBKG
					background_sound()

									## DIALOGUES ##
# Gestion des dialogues de ref 1 [DIALOGUES]
# Dialogues 
				if item.Template.Config.MessageSystem == false:
					last_dial()
					LOAD.time_delay = 1
					status()
					# Attribution du type de son
					sound = 1
					
					print("#### DIALOGUES REF : 1 ####")
			# Horodatage
					print("Horodatage")
					print("Création du label")
					LOAD.saveTime = LOAD.currentNextTime
					system_time()
					var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelTime")
					var label = labelbase.duplicate()
					print("Configuration du label")
					label.set_name("LabelTime")
					get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
					label.show()
					print("Affiche l'heure")
					if devMode == 0:
						label.set_text(str(" - ",LOAD.timeIG))
					else:
						label.set_text(str(" - ",LOAD.timeIG," : ",LOAD.currentDial))
					var labelH = label.get_text()
			# Auto Scroll
					print("Scroll")
					yield(get_tree(), "idle_frame")
					get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
					LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
					get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
			# Affichage Smoothie
					print("Affichage")
					LOAD.tween = get_node("Tween")
					LOAD.targetNode = label
					LOAD.tweenType = "visibility/opacity"
					LOAD.tweenStart = 0
					LOAD.tweenEnd = 1
					LOAD.tweenTime = 1.0
					LOAD.system_tween()
					
			#Création de la node LABEL
			########### REFONTE #############
					print("Traitement du Dialogue")
					actualContent = Text
					actualContent = actualContent.split("\r\n\r\n")
					for sentence in actualContent:
						print(str("CURRENTDIAL ACTUEL : ",sentence))
				
			# Calcule le nombre de charactères
						print("Calcule du nombre de charactère dans la phrase")
						size = (sentence.length())/20
						print("Définition du temps d'écriture en secondes")
			# Affiche le status "Ecrit un message"
						print("Création du label")
						var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelStat")
						var label = labelbase.duplicate()
						print("Configuration du label")
						label.set_name("LabelStatuts")
						get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
						label.show()
						print("Message système 'Ecrit un message'")
			# Auto Scroll
						print("Scroll")
						yield(get_tree(), "idle_frame")
						get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
						LOAD.vscroll = LOAD.vscroll+10+20
						get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
			# Affichage Smoothie
						print("Affichage")
						LOAD.tween = get_node("Tween")
						LOAD.targetNode = label
						LOAD.tweenType = "visibility/opacity"
						LOAD.tweenStart = 0
						LOAD.tweenEnd = 1
						LOAD.tweenTime = 1.0
						LOAD.system_tween()

			# Fourchettes en fonction de la taille du texte.
					# Inférieur à 0 seconde
						if size <= 0:
							size = 0.5
					# Entre 0 & 2 secondes
						elif size > 0 and size <= 2:
							size = 1.5
					# Entre 2 & 5 secondes
						elif size > 2 and size <= 5:
							size = 3.5
					# Entre 5 & 10 secondes
						elif size > 5 and size <= 10:
							size = 5
					# Supérieur à 10 secondes
						elif size > 10:
							size = 7
						print("Temps d'écriture : ",size," seconde(s)")

			# Lance le timer en fonction du nombre de char dans le content
						print("Lancement du timer",LOAD.time_delay," seconde(s)")
						LOAD.time_delay = size
						timer.set_wait_time(LOAD.time_delay)
						timer.start()
						yield(get_node("Timer"), "timeout")
						print("Fin du timer")

			# Temporisation courte entre le message système et le texte
						print("Temporisation : ",LOAD.time_delay," seconde(s)")
						LOAD.time_delay = 0.2
						timer.set_wait_time(LOAD.time_delay)
						timer.start()
						yield(get_node("Timer"), "timeout")
						label.queue_free()
						print("Fin du timer")		
			# Trigger son message reçu
						sample_msg()
						sound = 0
			# Ecrit la ligne de dialogue
						print("Création du label")
						var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelDial")
						var label = labelbase.duplicate()
						print("Configuration du label")
						label.set_name(str("label"))
						var labelname = label.get_name()
						var labelbg = str("vbox/Mid/DialBox/VBoxMid/",labelname,"/LabelBG")
						get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
						label.show()
						label.set_text(sentence)
			# Ajustement de la taille du label
						var labelsize = label.get_line_count()
						print(str("Nombre de ligne :",labelsize))
						if labelsize == 1:
							label.set_size(Vector2(925,50))
							label.set("rect/min_size",Vector2(925,50))
							get_node(labelbg).set("transform/scale",Vector2(1,1))
						elif labelsize == 2:
							label.set_size(Vector2(925,110))
							label.set("rect/min_size",Vector2(925,110))
							get_node(labelbg).set("transform/scale",Vector2(1,2))
						elif labelsize == 3:
							label.set_size(Vector2(925,170))
							label.set("rect/min_size",Vector2(925,170))
							get_node(labelbg).set("transform/scale",Vector2(1,3))
						elif labelsize == 4:
							label.set_size(Vector2(925,230))
							label.set("rect/min_size",Vector2(925,230))
							get_node(labelbg).set("transform/scale",Vector2(1,4))
						elif labelsize == 5:
							label.set_size(Vector2(925,290))
							label.set("rect/min_size",Vector2(925,290))
							get_node(labelbg).set("transform/scale",Vector2(1,5))
						print(str("Taille du label :",label.get_size()))
		
						# Auto Scroll
						print("Scroll")
						yield(get_tree(), "idle_frame")
						get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
						LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
						get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)

				# Affichage Smoothie
						print("Affichage")
						LOAD.tween = get_node("Tween")
						LOAD.targetNode = label
						LOAD.tweenType = "visibility/opacity"
						LOAD.tweenStart = 0
						LOAD.tweenEnd = 1
						LOAD.tweenTime = 1.0
						LOAD.system_tween()

				# Temporisation
						print("Temporisation : 0.75 seconde(s)")
						timer.set_wait_time(0.75)
						timer.start()
						yield(get_node("Timer"), "timeout")
						print("Fin du timer")
						print("Fin de la ligne")				
		
		
				if item.Template.Config.MessageSystem == true:
					last_dial()
					LOAD.time_delay = 1
					status()
					# Trigger son message système
					sound = 3
					sample_msg()
					#Création de la node LABEL
					########### REFONTE #############
					print("Traitement du Dialogue")
					actualContent = Text
					actualContent = actualContent.split("\r\n\r\n")
					for sentence in actualContent:
						print(str("CURRENTDIAL ACTUEL : ",sentence))
			
					# Calcule le nombre de charactères
						print("Calcule du nombre de charactère dans la phrase")
						size = (sentence.length())/20
						print("Définition du temps d'écriture en secondes")
					# Affiche le status "Ecrit un message"
						print("Création du label")
						var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelSys")
						var label = labelbase.duplicate()
						print("Configuration du label")
						label.set_name("LabelStatuts")
						get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
						label.show()
						label.set("visibility/opacity",1)
						label.set_text(sentence)
		
						# Auto scroll
						print("Scroll")
						yield(get_tree(), "idle_frame")
						get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
						LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
						get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
						
						# Temporisation
						timer.set_wait_time(1.25)
						timer.start()
						yield(get_node("Timer"), "timeout")	


		# Clos la boucle et passe au next
				#AUTO SAVE
				if LOAD.currentDial == LOAD.firstDial:
					print("Auto-Sauvegarde")
					unixTime = OS.get_unix_time()
					LOAD.dataDial = LOAD.currentDial
					LOAD.dataRep = null
					LOAD.dataNextTime = unixTime + int(LOAD.time_delay)
					system_save()
				print("Fin du dialogue")

				LOAD.launch = 1
				origin = 1
				find_next_target()
				
			##### REPONSES #####
			
			elif item.Type == "ReponseTemplate":
				get_node("vbox/Bot/ButtonChoices").set("disabled", 0)
				get_node("vbox/Bot/ButtonChoices/Label").set("visibility/visible", 1)
				print(str("NOMBRE DE BOUTON ?! :::", item.Properties.OutputPins.size()))
				for i in range(item.Properties.OutputPins.size()):
					get_node("Choices/Sprite").set("transform/scale", Vector2(2,i+2))
					if lastRep == false:
						buttonTarget.append(item.Properties.OutputPins[i].Connections[0].TargetPin)
					TargetPin = item.Properties.OutputPins[i].Id
					ConfigSoundTRG = item.Template.Config.soundTRG
					ConfigVolumeTRG = item.Template.Config.volumeTRG
					ConfigSoundBKG = item.Template.Config.soundBKG
					ConfigVolumeBKG = item.Template.Config.volumeBKG
					print(TargetPin)
					for caribou in LOAD.dial:
						if caribou.Properties.has("OutputPins") and caribou.Properties.OutputPins[0].has("Connections") and caribou.Properties.OutputPins[0].Connections[0].TargetPin == TargetPin:
							print("ENTREE DANS LE IF TARGETPIN")
							buttonName = caribou.Properties.MenuText
							if caribou.Properties.Text == "":
								buttonText.append(caribou.Properties.MenuText)
							else:
								buttonText.append(caribou.Properties.Text)
							get_node(str("Choices/VBox/Bouton",i)).set_text(str(buttonName))
							get_node(str("Choices/VBox/Bouton",i)).set_ignore_mouse(false)
							LOAD.tween = get_node("Tween")
							LOAD.targetNode = get_node(str("Choices/VBox/Bouton",i))
							LOAD.tweenType = "visibility/opacity"
							LOAD.tweenStart = 0
							LOAD.tweenEnd = 1
							LOAD.tweenTime = 1.0
							LOAD.system_tween()
						timer.stop()


										## BOUTONS REPONSES ##
# Boutons
# Gestion des boutons de choix multipes
# BOUTON 0
func _on_Bouton0_pressed():
	if lastRep == true:
		button_end()
	else:
		print("Bouton n°0 activé")
		buttonPressed = 0
		button_action()

# BOUTON 1
func _on_Bouton1_pressed():
	print("Bouton n°1 activé")
	buttonPressed = 1
	button_action()

# BOUTON 2
func _on_Bouton2_pressed():
	print("Bouton n°2 activé")
	buttonPressed = 2
	button_action()

# BOUTON 3
func _on_Bouton3_pressed():
	print("Bouton n°3 activé")
	buttonPressed = 3
	button_action()

############################### LES FONCTIONS ###############################
# Toutes les fonctions utiles
# Fonctions

# Nettoyage des boutons inutiles
# Clean
func clean():
	timer.set_wait_time(0.1)
	timer.start()
	yield(get_node("Timer"), "timeout")
	print("Fin du timer")
	print("Suppression des boutons")
	for i in range(4):
		get_node(str("Choices/VBox/Bouton",i)).set_ignore_mouse(true)
		if get_node(str("Choices/VBox/Bouton",i)).get("visibility/opacity") == 1:
			LOAD.tween = get_node("Tween")
			LOAD.targetNode = get_node(str("Choices/VBox/Bouton",i))
			LOAD.tweenType = "visibility/opacity"
			LOAD.tweenStart = 1
			LOAD.tweenEnd = 0
			LOAD.tweenTime = 0.2
			LOAD.system_tween()
			#get_node(str("vbox/Bot/VBoxBot/Bouton",i,"/Label",i)).set_text("")
	return

# Button Action
func button_action():
	get_node("Choices").hide()
	get_node("vbox/Bot/ButtonChoices").set("disabled", 1)
	get_node("vbox/Bot/ButtonChoices/Label").set("visibility/visible", 0)
	# Vérification d'un trigger son
	if ConfigSoundTRG != "":
		triggerName = ConfigSoundTRG
		triggerVol = ConfigVolumeTRG
		trigger_sound()
	if ConfigSoundBKG != "":
		bg_sound = ConfigSoundBKG
		bg_sound_vol = ConfigVolumeBKG
		background_sound()

	# AUTO SAVE
	LOAD.dataDial = LOAD.currentDial
	LOAD.dataRep = buttonPressed
	LOAD.dataNextTime = OS.get_unix_time() + int(LOAD.time_delay)
	if ConfigSoundBKG != "":
		bg_sound = ConfigSoundBKG
		LOAD.actualBGSound = bg_sound
	system_save()
# Trigger son message envoyé
	sound = 2
	sample_msg()

# Ecrit une ligne de Dialogue
	print("Création du label")
	var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelRep")
	var label = labelbase.duplicate()
	print("Configuration du label")
	label.set_name(str("label",buttonText,buttonPressed))
	get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
	label.show()
	print("Ecrit la ligne de dialogue : ",buttonText[buttonPressed])
	label.set_text(str(buttonText[buttonPressed]))
	print(str("buttonTarget : ",buttonTarget[buttonPressed]))

	origin = 0
	find_next_target()
			
	print(str("currentDial : ",LOAD.currentDial))
	print(str("timeDelay : ",LOAD.time_delay))
	#AUTO SAVE
	LOAD.dataDial = LOAD.currentDial
	LOAD.dataRep = null
	LOAD.dataNextTime = OS.get_unix_time() + int(LOAD.time_delay)
	LOAD.currentNextTime = LOAD.dataNextTime
	if ConfigSoundBKG != "":
		bg_sound = ConfigSoundBKG
		LOAD.actualBGSound = bg_sound
	system_save()
	LOAD.launch = 1

	buttonText = []
	buttonTarget = []

	print("Nettoyage des boutons")
	clean()

# Ajustement de la taille du label
	var labelsize = label.get_line_count()
	print(str("Nombre de ligne :",labelsize))
	if labelsize == 1:
		label.set_size(Vector2(925,55))
		label.set("rect/min_size",Vector2(925,55))
	elif labelsize == 2:
		label.set_size(Vector2(925,110))
		label.set("rect/min_size",Vector2(925,110))
	elif labelsize == 3:
		label.set_size(Vector2(925,170))
		label.set("rect/min_size",Vector2(925,170))
	elif labelsize == 4:
		label.set_size(Vector2(925,230))
		label.set("rect/min_size",Vector2(925,230))
	elif labelsize == 5:
		label.set_size(Vector2(925,290))
		label.set("rect/min_size",Vector2(925,290))
	print(str("Taille du label :",label.get_size()))

# Auto Scroll
	print("Scroll")
	yield(get_tree(), "idle_frame")
	get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
	LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
	get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
# Affichage Smoothie
	print("Affichage")
	LOAD.tween = get_node("Tween")
	LOAD.targetNode = label
	LOAD.tweenType = "visibility/opacity"
	LOAD.tweenStart = 0
	LOAD.tweenEnd = 1
	LOAD.tweenTime = 1.0
	LOAD.system_tween()
	status()
	return

func find_next_target():
	for orignal in LOAD.dial:
		# Trouve la prochaine Target depuis un choix multiple
		if origin == 0:
			if orignal.Properties.InputPins[0].Id == buttonTarget[buttonPressed]:
				LOAD.currentDial = orignal.Properties.DisplayName
				LOAD.time_delay = orignal.Template.Config.Timer
				return
		# Trouve la prochaine Target depuis un dialogue
		if origin == 1:
			if orignal.Properties.Id == Target:
				LOAD.currentDial = orignal.Properties.DisplayName
				LOAD.time_delay = orignal.Template.Config.Timer
				print("Lancement du timer",LOAD.time_delay," seconde(s)")
				LOAD.currentNextTime = OS.get_unix_time() + int(LOAD.time_delay)
				if orignal.Type == "DialogueTemplate":
					print(str("TARGET : ",Target))
					print("Auto-Sauvegarde")
					unixTime = OS.get_unix_time()
					LOAD.dataDial = LOAD.currentDial
					LOAD.dataRep = null
					LOAD.dataNextTime = unixTime + int(LOAD.time_delay)
					if ConfigSoundBKG != "":
						bg_sound = ConfigSoundBKG
						LOAD.actualBGSound = bg_sound
					system_save()
					status()
				return
	

# Bouton de fin (retour menu)
func button_end():
	LOAD.saveDial = []
	LOAD.saveRep = []
	LOAD.saveTime = []
	LOAD.saveNextTime = []
	get_tree().change_scene("res://scn/menu.tscn")

# Status
func status():
# Status de l'interlocuteur
	print("Status de l'interlocuteur")
	# En ligne
	if LOAD.time_delay < 30:
		statusText = LOAD.gameText[0]
		# Modification de la LED
		get_node("vbox/Top/LED").set_region_rect(Rect2(Vector2(573,69),Vector2(48,49)))
		status = 1
	# Occupé
	elif LOAD.time_delay >= 30 and LOAD.time_delay <= 180:
		statusText = LOAD.gameText[1]
		# Modification de la LED
		get_node("vbox/Top/LED").set_region_rect(Rect2(Vector2(578,21),Vector2(37,37)))
		status = 2
	# Absent
	elif LOAD.time_delay > 180 and LOAD.time_delay <= 300:
		statusText = LOAD.gameText[2]
		# Modification de la LED
		get_node("vbox/Top/LED").set_region_rect(Rect2(Vector2(634,21),Vector2(37,37)))
		status = 3
	# Hors Ligne
	elif LOAD.time_delay > 300:
		statusText = LOAD.gameText[3]
		# Modification de la LED
		get_node("vbox/Top/LED").set_region_rect(Rect2(Vector2(634,75),Vector2(37,37)))
		status = 4

	# Vérification du changement de status
	if status != statusNext:
		message_system()
		statusNext = status
	return

# Message système status interlocuteur
func message_system():
	# Trigger son message système
	sound = 3
	sample_msg()
	# Message système
	print("Modification vignette status")
	get_node("vbox/Top/Etat").clear()
	get_node("vbox/Top/Etat").add_text(str(LOAD.gameText[5]," : ",statusText))
	print("Création du label")
	var labelbase = get_node("vbox/Mid/DialBox/VBoxMid/LabelSys")
	var label = labelbase.duplicate()
	print("Configuration du label")
	label.set_name(str("label",LOAD.currentDial))
	get_node("vbox/Mid/DialBox/VBoxMid").add_child(label)
	label.show()
	label.set_text(str(LOAD.gameText[6],statusText))
	
	# Affichage smoothie
	print("Affichage")
	label.set("visibility/opacity",1)

	# Temporisation
	timer.set_wait_time(0.75)
	timer.start()
	yield(get_node("Timer"), "timeout")

	# Auto scroll
	print("Scroll")
	yield(get_tree(), "idle_frame")
	get_node("vbox/Mid/DialBox").set_enable_v_scroll(true)
	LOAD.vscroll = LOAD.vscroll+label.get_size().height+20
	get_node("vbox/Mid/DialBox").set_v_scroll(LOAD.vscroll)
	return

# Reset Save
# Reset de la sauvegarde
func _on_resetSave_pressed():
	get_node("Popup").popup()


# System Save
# SYSTEME DE SAUVEGARDE
func system_save():
	print("SYSTEM SAVE")
	LOAD.saveDial.push_back(LOAD.dataDial)
	LOAD.saveRep.push_back(LOAD.dataRep)
	LOAD.saveNextTime.push_back(LOAD.dataNextTime)
	print(LOAD.saveDial)
	print(LOAD.saveRep)
	print(LOAD.saveNextTime)
	data = {"_Save" : {"dial" : LOAD.saveDial,"rep" : LOAD.saveRep, "nexttime" : LOAD.saveNextTime, "actualBGSound" : LOAD.actualBGSound}}
	var file = File.new()
	#file.open_encrypted_with_pass("user://savelogs.json", File.WRITE, "reg65er9g84zertg1zs9ert8g4")
	file.open(str("user://save",LOAD.scenarioFile,".json"), File.WRITE)
	file.store_line(data.to_json())
	file.close()
	return

# System Time
func system_time():
	# Récupération de l'heure du système
	var timeSys = OS.get_datetime_from_unix_time(LOAD.saveTime)
	var hourSys = timeSys.hour
	var minuteSys = timeSys.minute
	var secondSys = timeSys.second
	hourSys = hourSys + (calcultime)

	# Ajustement de l'heure
	if hourSys < 10:
		hourIG = str("0",hourSys)
	else:
		hourIG = hourSys
	if minuteSys < 10:
		minuteIG = str("0",minuteSys)
	else:
		minuteIG = minuteSys
	if secondSys < 10:
		secondIG = str("0",secondSys)
	else:
		secondIG = secondSys

	LOAD.timeIG = str(hourIG,":",minuteIG,":",secondIG)
	return

# Vérification FIN
func last_dial():
	if LOAD.currentDial == LOAD.lastDial:
		lastRep = true
		print(str("LASTREP : ",lastRep))
		if LOAD.loadChapter >= LOAD.chapterSave:
			LOAD.chapterSave = LOAD.chapterSave+1
			LOAD.data = {"_SaveGlobal" : {"chapter" : LOAD.chapterSave}}
			var file = File.new()
			#file.open_encrypted_with_pass("user://savelogs.json", File.WRITE, "reg65er9g84zertg1zs9ert8g4")
			file.open("user://saveglobal.json", File.WRITE)
			file.store_line(LOAD.data.to_json())
			file.close()
	return

# Système de sample MESSAGES
func sample_msg():
	if LOAD.SoundButton == 1:
		if sound == 1:
			sampleMSG = load("res://snd/msg_received.ogg")
			get_node("SampleMSG").set_stream(sampleMSG)
			get_node("SampleMSG").play(0)
		elif sound == 2:
			sampleMSG = load("res://snd/msg_send.ogg")
			get_node("SampleMSG").set_stream(sampleMSG)
			get_node("SampleMSG").play(0)
		elif sound == 3:
			sampleMSG = load("res://snd/msg_sys.ogg")
			get_node("SampleMSG").set_stream(sampleMSG)
			get_node("SampleMSG").play(0)
	return

# Système de trigger son
func trigger_sound():
	actualSound = load(str("res://snd/",triggerName,".ogg"))
	get_node("SampleTRG").set_stream(actualSound)
	get_node("SampleTRG").set("stream/volume_db",triggerVol)
	if LOAD.MusicButton == 1:
		get_node("SampleTRG").play(0)
	return

# Système de sons d'ambiance (background sound)
func background_sound():
	actualSound = load(str("res://snd/",bg_sound,".ogg"))
	get_node("SampleBKG").set_stream(actualSound)
	get_node("SampleBKG").set("stream/volume_db",bg_sound_vol)
	if LOAD.MusicButton == 1:
		get_node("SampleBKG").play(0)
	return

# System Option Sons
func soundOptions():
	if LOAD.MusicButton == 1:
		get_node("Popup/VBox/Sound/MusicButton").set_modulate(Color("#2873f3"))
		if get_node("SampleBKG").is_playing() == 0:
			get_node("SampleBKG").play(0)
	elif LOAD.MusicButton == 0:
		get_node("Popup/VBox/Sound/MusicButton").set_modulate(Color("#898989"))
		if get_node("SampleBKG").is_playing() == 1:
			get_node("SampleBKG").stop()
	if LOAD.SoundButton == 1:
		get_node("Popup/VBox/Sound/SoundButton").set_modulate(Color("#2873f3"))
	elif LOAD.SoundButton == 0:
		get_node("Popup/VBox/Sound/SoundButton").set_modulate(Color("#898989"))
	return

# System Exit
func system_exit():
	for item in LOAD.dial:
		if item.Properties.has("DisplayName") and item.Properties.DisplayName == LOAD.currentDial and LOAD.launch == 0:
			if item.Type == "DialogueTemplate":
				Target = item.Properties.OutputPins[0].Connections[0].Target
				for itemc in LOAD.dial:
					if itemc.Properties.Id == Target and itemc.Type == "DialogueTemplate":
						LOAD.time_delay = itemc.Template.Config.Timer
						LOAD.dataDial = itemc.Properties.DisplayName
						LOAD.dataRep = null 
						LOAD.dataNextTime = OS.get_unix_time() + int(LOAD.time_delay)
						bg_sound = ConfigSoundBKG
						LOAD.actualBGSound = bg_sound
						system_save()

func _notification(notification_signal):
	if notification_signal == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		system_exit()

func _on_Reset_pressed():
	Directory.new().remove(str("user://save",LOAD.scenarioFile,".json"))
	LOAD.saveDial = []
	LOAD.saveRep = []
	LOAD.saveTime = []
	LOAD.saveNextTime = []
	LOAD._load_chapter()
	return

func _on_Site_pressed():
	OS.shell_open("http://www.chroniquesdetalos.com")

func _on_Twitter_pressed():
	OS.shell_open("https://twitter.com/ChroniquesTalos")

func _on_Facebook_pressed():
	OS.shell_open("https://www.facebook.com/chroniquesdetalos/")

func _on_Youtube_pressed():
	OS.shell_open("https://www.youtube.com/channel/UCi_4enQ0P4U7XKdcP9340cg")

func _on_Retour_pressed():
	get_node("Popup").hide()

func _on_Quitter_pressed():
	LOAD.saveDial = []
	LOAD.saveRep = []
	LOAD.saveTime = []
	LOAD.saveNextTime = []
	get_tree().change_scene("res://scn/menu.tscn")


func _on_MusicButton_pressed():
	if LOAD.MusicButton == 1:
		LOAD.MusicButton = 0
		soundOptions()
	elif LOAD.MusicButton == 0:
		LOAD.MusicButton = 1
		soundOptions()
	LOAD.saveGlobal()
	return


func _on_SoundButton_pressed():
	if LOAD.SoundButton == 1:
		LOAD.SoundButton = 0
		soundOptions()
	elif LOAD.SoundButton == 0:
		LOAD.SoundButton = 1
		soundOptions()
	LOAD.saveGlobal()
	return

func _on_ButtonChoices_pressed():
	get_node("Choices").popup()


func _on_LeaveChoices_pressed():
	get_node("Choices").hide()


func _on_LeaveOptions_pressed():
	get_node("Popup").hide()
