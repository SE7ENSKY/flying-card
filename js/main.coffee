class card3D
    constructor: (nodeEl) ->
        @$block = $(nodeEl)
        @cacheVars()
        @bindEvents()
        @presetCss()

    cacheVars: ->
        @cardContainerClassName = @$block.attr("class")
        @$rotateElement = @$block.find(".#{ @cardContainerClassName }__link")
        @$shiningEffect = @$block.find(".#{ @cardContainerClassName }__shining")
        @$parallaxLayer = @$rotateElement.find(">*:not(.#{ @cardContainerClassName }__shining):not(.#{ @cardContainerClassName }__base)")

        @perspective = 500
        @hoverTranslateZ = 30
        @parallaxZRate = 10
        @rotationRateX = 0.03
        @rotationRateY = 0.02
        @ambientLightRatio = 1.9
        @gradientSaturation = 100

    presetCss: ->
        TweenMax.set(@$block, { perspective: @perspective, transformStyle: "preserve-3d" })
        TweenMax.set(@$rotateElement, { transformStyle: "preserve-3d" })
        TweenMax.set(@$shiningEffect, { autoAlpha: 0 })

    calculateDegree = (coordinate, rate) ->
        coordinate * rate

    ambientLight = (cX, x, cY, y, rate) ->
        Math.sqrt( Math.pow(cX - x, 2) + Math.pow(cY - y, 2) ) / Math.sqrt( Math.pow(x, 2) + Math.pow(y, 2) ) / rate

    transformElement = (element, duration, easing, yRotation, xRotation, zСoordinate) ->
        TweenMax.to(element, duration, {
            ease: easing
            rotationY: yRotation
            rotationX: xRotation
            z: zСoordinate
        })

    performShining = (element, angle, opacity, saturation) ->
        element.css("background", "linear-gradient(#{ angle }deg, rgba(255,255,255,#{ opacity }) 0%, rgba(255,255,255,0) #{ saturation }%)")

    moveLayers = (element, duration, easing, parallaxZRate) ->
        elementAmount = element.length
        return if elementAmount == 0
        element.each (i, item) ->
            console.log i
            TweenMax.to(item, duration, {
                ease: easing
                z: (parallaxZRate * i)
            })

    changeAlphaChannel = (element, duration, easing, value) ->
        TweenMax.to(element, duration, {
            ease: easing
            autoAlpha: value
        })

    calculateTransform = (event) ->
        rotateElementWidth = @$rotateElement.width()
        rotateElementHeight = @$rotateElement.height()

        posX = event.pageX - @$rotateElement.offset().left
        posY = event.pageY - @$rotateElement.offset().top - @hoverTranslateZ

        centerX = rotateElementWidth / 2
        centerY = rotateElementHeight / 2

        dX = posX - centerX
        dY = posY - centerY

        radians = Math.atan2(posX - centerX, posY - centerY)
        angle = radians * (180 / Math.PI) * -1
        angle = angle + 360 if angle < 0

        performShining(@$shiningEffect, angle, ambientLight(posX, centerX, posY, centerY, @ambientLightRatio), @gradientSaturation)
        transformElement(@$rotateElement, 0.1, Power2.easeOut, calculateDegree(dX, @rotationRateX), calculateDegree(-dY, @rotationRateY), @hoverTranslateZ)

    setStyle = ->
        changeAlphaChannel(@$shiningEffect, 0.2, Power2.easeOut, 1)
        moveLayers(@$parallaxLayer, 0.1, Power2.easeOut, @parallaxZRate)

    removeStyle = ->
        transformElement(@$rotateElement, 0.1, Power2.easeIn, 0, 0, 0)
        changeAlphaChannel(@$shiningEffect, 0.2, Power2.easeOut, 0)
        moveLayers(@$parallaxLayer, 0.1, Power2.easeOut, 0)

    bindEvents: ->
        @$block.on "mousemove", calculateTransform.bind(@)
        @$block.on "mouseover", setStyle.bind(@)
        @$block.on "mouseleave", removeStyle.bind(@)

$('.card').each ->
    new card3D @
