# This imports all the layers for "DropTicket_ticket_detail" into dropticket_ticket_detailLayers
Framer.Device.contentScale = 1.5
Framer.Device.deviceScale = 0.33

SCALEFACTOR = 2
STATUSBARHEIGHT = 25*SCALEFACTOR
ACTIONBARHEIGHT = 48*SCALEFACTOR
MARGIN = 8 * SCALEFACTOR
LABELHEIGHT = 24 * SCALEFACTOR
BOXHEIGHT = 80 * SCALEFACTOR

NUMBER_OF_TICKETS = 8
TICKET_CLOSED_HEIGHT = MARGIN*2+BOXHEIGHT
TICKET_OPEN_HEIGHT = 1280-STATUSBARHEIGHT-ACTIONBARHEIGHT*2-MARGIN*2
TICKET_WIDTH = 360*SCALEFACTOR-MARGIN*2
# Background, Import, Position and Animation Defaults –––––––––––––––––––
document.body.style.background = "#339bcb"

# This imports all the layers for "DigiPen_shop.psd" into digipen_shopPsdLayers
psdLayers = Framer.Importer.load "imported/DropTicket_ticket_detail"

#psdLayers.root.center() #uncomment for browser centering
psdLayers.root.shadowY = 3
psdLayers.root.shadowBlur = 15
psdLayers.root.shadowColor = "rgba(0, 0, 0, 0.6)"
psdLayers.root.clip = true

materialCurveMove = "cubic-bezier(0.4, 0, 0.2, 1)"
materialCurveEnter = "cubic-bezier(0, 0, 0.2, 1)"
materialCurveExit = "cubic-bezier(0.4, 0, 1, 1)"

Framer.Defaults.Animation =
	curve: materialCurveMove
	time: 0.6

Ticket = (type, ticketId) ->
	icons = [psdLayers["bus_icon"], psdLayers["parking_icon"], psdLayers["ztl_icon"], psdLayers["bike_icon"], psdLayers["bike_icon"]]
	texts = [
		['Corsa semplice', 'Start Romagna', 'Durata: 1 ora 30 minuti'],
		["Sosta breve", "AMT Catania", "Durata: 1 ora"], 
		["Accesso", "Centro urbano", "Durata: 90 minuti"],
		["Corsa media", "GoBike", "Durata: 3 ore"],
		["Biglietto Combinato", "MetroBus", "Durata: 3 ore"]
	]
	flatColors = ["#f2a832", "#2785e5", "#ec494c", "#49c80d", "#808080"]
	textButtons = ["€1.50", "€1.00", "€2.50", "€3.00", "€6.00"]
	
	textSizes = ["36px", "28px", "24px"]
	textStyles = ["bold", "normal", "italic"]
	textColors = ["#000", "#888", "#888"]
	textOffsets = [0, LABELHEIGHT, BOXHEIGHT-LABELHEIGHT]
	textWeights = [500, 400, 400]
	
	ticket = new Layer
		x: MARGIN, y: ticketId*(MARGIN*3+BOXHEIGHT)+MARGIN, width: TICKET_WIDTH, height: MARGIN*2+BOXHEIGHT
		backgroundColor: "#ffffff", borderRadius: 4 * SCALEFACTOR
		shadowY: 4, shadowBlur: 0, shadowColor: "rgba(0, 0, 0, 0.15)", name: "ticket"
	ticket.open = false
	ticket.ticketId = ticketId
	ticket.states.add
		maximized: {
			y: -> -(this.superLayer.y - MARGIN)
			height: TICKET_OPEN_HEIGHT
		}
	
	ticket.colorbox = new Layer
		superLayer: ticket,
		x: MARGIN, y: MARGIN, width: BOXHEIGHT, height: BOXHEIGHT, borderRadius: 2 * SCALEFACTOR,
	ticket.colorbox.style = background: flatColors[type]
	ticket.colorbox.states.add
		maximized: {width: TICKET_WIDTH-MARGIN*2}
	
	ticket.icon = new Layer
		superLayer: ticket.colorbox,
		midX: BOXHEIGHT * 0.5, midY: BOXHEIGHT * 0.5,
		width: icons[type].width, height: icons[type].height
		image: icons[type].image
	
	ticket.button = new Layer
		superLayer: ticket,
		borderRadius: 2 * SCALEFACTOR
		maxX: TICKET_WIDTH-MARGIN*2, y: MARGIN*2, width: 144, height: LABELHEIGHT+MARGIN,
	ticket.button.html = textButtons[type]		
	ticket.button.style =
		fontFamily: "Roboto", lineHeight: LABELHEIGHT+MARGIN+"px", textAlign: "center"
		fontSize: "28px", fontStyle: textStyles[i]
		fontWeight: 500, color: '#fff'
		background: flatColors[type], borderColor: "#fff", borderWidth: (1*SCALEFACTOR)+"px", borderStyle: "solid"
		
	ticket.bigButton = new Layer
		superLayer: ticket,
		borderRadius: 2 * SCALEFACTOR
		x: MARGIN, y: TICKET_OPEN_HEIGHT-MARGIN-LABELHEIGHT*2
		width: TICKET_WIDTH-MARGIN*2, height: LABELHEIGHT*2,
		backgroundColor: flatColors[type]
	ticket.bigButton.html = "Acquista"
	ticket.bigButton.style =
		fontFamily: "Roboto", lineHeight: LABELHEIGHT*2+"px", textAlign: "center"
		fontSize: "36px", fontStyle: textStyles[i]
		fontWeight: 500, color: '#fff'
	ticket.bigButton.states.add
		pressed: {opacity: 0.5}
	ticket.bigButton.on Events.Click, (e) ->
		ticket.states.next()
		this.states.switchInstant "pressed"
		this.states.switch "default"
		undoDialog(flatColors[type])
	
	ticket.texts = for textValue, i in texts[type]
		text = new Layer
			superLayer: ticket
			backgroundColor: "transparent"
			x: MARGIN*2 + ticket.colorbox.width, y: textOffsets[i], width: 360, height: LABELHEIGHT*1.5,
		text.html = textValue
		text.style = 
			fontFamily: "Roboto", lineHeight: '88px',
			fontSize: textSizes[i], fontStyle: textStyles[i],
			fontWeight: textWeights[i], color: textColors[i],
		text.states.add
			hidden: {opacity: 0}
		text
	ticket.whiteTexts = for textValue, i in texts[type]
		text = new Layer
			superLayer: ticket,
			backgroundColor: "transparent"
			x: MARGIN*2 + ticket.colorbox.width, y: textOffsets[i], width: 360, height: LABELHEIGHT * 1.5,
		text.html = textValue
		text.style = 
			fontFamily: "Roboto", lineHeight: '88px',
			fontSize: textSizes[i], fontStyle: textStyles[i],
			fontWeight: textWeights[i], color: 'white',
		text.states.add
			hidden: {opacity: 0}
		text.states.switchInstant "hidden"
		text
	
	ticket.progress = new Layer
		superLayer: ticket
		x: MARGIN*2 + ticket.colorbox.width, y: BOXHEIGHT-LABELHEIGHT+MARGIN
		width: ticket.width - MARGIN*4 - ticket.colorbox.width, height: 2*SCALEFACTOR
		backgroundColor: "#888"
	ticket.progress.states.add
		white: { brightness: 200 }
		
	ticket.qrCode = new Layer
		superLayer: ticket
		x:0, y:176, width:264, height:264,
		image: "https://chart.googleapis.com/chart?chs=264x264&cht=qr&chl=DropTicket&choe=UTF-8&chld=H"
	
	ticket.QRtexts = for lbl, i in ["ID", "Data di acquisto"]
		rowText = new Layer
			superLayer: ticket
			x: 256, y:176 + i*88 + 44, width: 408, height: 88,
			backgroundColor: "transparent"
		rowText.html = lbl
		rowText.style = 
			fontFamily: "Roboto", lineHeight: '88px',
			fontSize: "28px", fontStyle: "normal",
			fontWeight: 500, color: '#000', textAlign: "left"
		rowText
		
	ticket.QRtexts = for lbl, i in ["PotEjjrbxfPr7ya0o", "28 ago 17:28"]
		rowText = new Layer
			superLayer: ticket
			x: 256, y:176 + i*88 + 44, width: 408, height: 88,
			backgroundColor: "transparent"
		rowText.html = lbl
		rowText.style = 
			fontFamily: "Roboto", lineHeight: '88px',
			fontSize: "28px", fontStyle: "normal",
			fontWeight: 500, color: '#000', textAlign: "right"
		rowText
		
	ticket.textsDown = for lbl, i in ["Linea", "Check-in"]
		rowText = new Layer
			superLayer: ticket
			x: 32, y:440 + i*88, width: 408, height: 88,
			backgroundColor: "transparent"
		rowText.html = lbl
		rowText.style = 
			fontFamily: "Roboto", lineHeight: '88px',
			fontSize: "36px", fontStyle: "normal",
			fontWeight: 500, color: '#000', textAlign: "left"
		rowText
		
	ticket.textsDown = for lbl, i in ["A", "29 ago 12:24"]
		rowText = new Layer
			superLayer: ticket
			x: 32, y:440 + i*88, width: 632, height: 88,
			backgroundColor: "transparent"
		rowText.html = lbl
		rowText.style = 
			fontFamily: "Roboto", lineHeight: '88px',
			fontSize: "36px", fontStyle: "normal",
			fontWeight: 500, color: '#000', textAlign: "right"
		rowText
	
	ticket.on Events.StateWillSwitch, (prev, curr) ->
		fade.bringToFront()
		this.bringToFront()
		if prev is "default" and curr is "maximized"
			ticketGroup.draggable.enabled = false
			fade.states.switch "default"
			ticket.colorbox.states.switch "maximized"
			for t in ticket.texts
				t.states.switch "hidden"
			for t in ticket.whiteTexts
				t.states.switch "default"
			ticket.progress.states.switch "white"
		else if prev is "maximized" and curr is "default"
			ticketGroup.draggable.enabled = true
			fade.states.switch "hidden"
			ticket.colorbox.states.switch "default"
			for t in ticket.texts
				t.states.switch "default"
			for t in ticket.whiteTexts
				t.states.switch "hidden"
			ticket.progress.states.switch "default"
			
	ticket.on Events.Click, (e) ->
		ticket.states.next()
		
	ticket

#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
#UNDO DIALOG
DIALOG_MARGIN = 24 *SCALEFACTOR
DIALOG_BUTTON_HEIGHT = 48 *SCALEFACTOR
# DIALOG_BUTTON_MARGIN = 16 *SCALEFACTOR
undoDialog = (color) ->
	fade = new Layer
		x: 0, y: 0
		width: 360*SCALEFACTOR, height: 1280
		backgroundColor: "rgba(0,0,0, 0.5)"
		ignoreEvents: false
	fade.states.add
		hidden: {opacity: 0.0}
	fade.states.switchInstant "hidden"
	
	dialog = new Layer
		superLayer: fade
		midX: 180*SCALEFACTOR, midY: 320*SCALEFACTOR
		width: 240*SCALEFACTOR, height: 180*SCALEFACTOR
		borderRadius: 4*SCALEFACTOR+"px"
		backgroundColor: "#fff"
	
	title = new Layer
		superLayer: dialog
		x: DIALOG_MARGIN, y: DIALOG_MARGIN
		width: dialog.width-DIALOG_MARGIN*2
		height: LABELHEIGHT
		backgroundColor: "transparent"
	title.html = "Acquisto biglietto"
	title.style = 
		fontFamily: "Roboto", lineHeight: LABELHEIGHT+"px",
		fontSize: "36px", fontStyle: "normal",
		fontWeight: 500, color: '#000', textAlign: "center"
		
	psdLayers["activity_indicator"].superLayer = dialog
	psdLayers["activity_indicator"].center()
	psdLayers["activity_indicator"].animate
		properties: rotation: 360
		repeat: 10000
		time: 1
		curve: "linear"
		
	undo = new Layer
		superLayer: dialog
		x: 0, y: dialog.height-DIALOG_BUTTON_HEIGHT
		width: dialog.width, height: DIALOG_BUTTON_HEIGHT
		backgroundColor: "transparent"
	undo.html = "Annulla acquisto"
	undo.style = 
		fontFamily: "Roboto", lineHeight: DIALOG_BUTTON_HEIGHT+"px",
		fontSize: "28px", fontStyle: "normal",
		fontWeight: 400, color: '#000', textAlign: "center"
		borderStyle: "solid", borderColor: "#ccc", borderWidth: "1px 0px 0px 0px"
	
	undo.on Events.Click, () ->
		fade.states.switch "hidden"
		
	Utils.delay 2, () ->
		fade.states.switch "hidden"
		
	fade.on Events.StateDidSwitch, (prev, curr) ->
		if prev is "default" and curr is "hidden"
			psdLayers["activity_indicator"].superLayer = null
			psdLayers["activity_indicator"].sendToBack()
			this.destroy()
	
	fade.states.switch "default"

#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


ticketGroup = new Layer
	superLayer: psdLayers["BG"]
	x: 0, y: 0
	width: 360*SCALEFACTOR, height: NUMBER_OF_TICKETS*(MARGIN*3+BOXHEIGHT)+MARGIN
	backgroundColor: "transparent"
ticketGroup.draggable.enabled = true
ticketGroup.draggable.speedX = 0
ticketGroup.draggable.speedY = 1/SCALEFACTOR
ticketGroup.snapView = () ->
	snapfactor = (MARGIN*3+BOXHEIGHT)
	velocity = this.draggable.calculateVelocity()
	clampedVelocity = Math.max(-snapfactor, Math.min(velocity.y*100, snapfactor))
	this.targetY = Math.round((this.y+clampedVelocity)/snapfactor) * snapfactor
	this.targetY = Math.min(0, Math.max(this.targetY, -(this.height-psdLayers["BG"].height+MARGIN)))
	this.animate
		properties:
			y: this.targetY

ticketGroup.on Events.DragMove, () ->
	for l in this.subLayers
		l.ignoreEvents = true
ticketGroup.on Events.DragEnd, () ->
	this.snapView()
	for l in this.subLayers
		l.ignoreEvents = false
	
fade = new Layer
	superLayer: ticketGroup
	x: 0, y: 0
	width: 360*SCALEFACTOR, height: ticketGroup.height
	backgroundColor: "rgba(0,0,0, 0.5)"
fade.states.add
	hidden: {opacity: 0}
fade.states.switchInstant "hidden"

fade.on Events.StateDidSwitch, (prev, curr) ->
	if prev is "default" and curr is "hidden"
		this.visible = false
	else if prev is "hidden" and curr is "default"
		this.visible = true
		
fade.on Events.StateWillSwitch, (prev, curr) ->
	if prev is "hidden" and curr is "default"
		this.visible = true
		
for i in [0..NUMBER_OF_TICKETS-1]
	randomType = Utils.randomNumber(0,4) | 0
	linearType = i%5
	ticketGroup.addSubLayer Ticket(linearType, i)