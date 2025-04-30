breed[leoes leao]
breed[hienas hiena]


turtles-own [energia localX localY percL percH descanso]
hienas-own [agrupamento]

to setup
  setup-patches
  setup-turtles
  reset-ticks
end

to setup-patches
  clear-all
  set-patch-size 15
  ask patches
  [
    let r random 101
    if r <= percV and percV != 0 [
      set pcolor red
    ]
    set r random 101 - percV
    if r <= percC and percC != 0 and pcolor != red [
      set pcolor brown
    ]

  ]
  ask n-of percA patches

  [ set pcolor blue ]



end



to setup-turtles
  clear-turtles
  create-leoes nleao
  [

    set localX 1000
    set localY 1000
    set energia qenergia
    set percL penergL
    set shape "wolf"
    set color yellow
    set heading 90
    setxy random-xcor random-ycor
    while [[pcolor] of patch-here = red]
    [
      setxy random-xcor random-ycor
    ]
  ]
  create-hienas nhienas
  [
    set energia qenergia
    set percH penergH
    set agrupamento 1
    set shape "wolf"
    set color gray
    setxy random-xcor random-ycor
    while [[pcolor] of patch-here != black]
    [
      setxy random-xcor random-ycor
    ]
  ]
end

to go
  moveH
  moveL
  check-agrupa
  ver-morte
  if count turtles = 0
  [
    stop
  ]
  tick
  display-labels
end


to moveL
  ask leoes [
    let cor_frente [pcolor] of patch-ahead 1
    let cor_esquerda [pcolor] of patch-left-and-ahead 90 1
    let cor_direita [pcolor] of patch-right-and-ahead 90 1
    let hienas-esquerda count hienas-on patch-left-and-ahead 1 0
    let hienas-direita count hienas-on patch-right-and-ahead 1 0
    let hienas-frente count hienas-on patch-ahead 1

    if reproducao? and count hienas != 0 [reproduzir-leoes]

      ifelse descanso > 0
      [set descanso descanso - 1]
      [

        ifelse hienas-frente + hienas-direita + hienas-esquerda = 1 [
          ask hienas in-radius 1 [die]
        ]
        [
          ifelse hienas-frente + hienas-direita + hienas-esquerda >= 2 [
            fuga-leoes
          ]

          [
            ifelse cor_frente = red or cor_frente = brown or cor_frente = blue [
              if cor_frente = brown [
                fd 1
                set energia energia + energiaAlimento
                ask patch-here [set pcolor black]
                ask one-of patches with [pcolor = black] [set pcolor brown]
              ]
              if cor_frente = red [
                fd 1
                set energia energia + energiaAlimento
                ask patch-here [set pcolor brown]
              ]
              ifelse cor_frente = blue and count leoes-on patch-ahead 1 = 0 [
                fd 1
                set descanso tempo_descanso
              ]
              [
                rt 90
                fd 1
              ]
            ]
            [
              ifelse cor_esquerda = red or cor_esquerda = brown or cor_esquerda = blue [
                rt 270
                set energia energia - 1
              ]


              [
                ifelse cor_direita = red or cor_direita = brown or cor_direita = blue [
                  set energia energia - 1
                  rt 90
                ]
                [
                  ifelse cor_frente != red and cor_frente != brown [
                    fd 1
                    set energia energia - 1
                  ]
                  [
                    set energia energia - 1
                  ]
                ]

              ]
      ]]]
  ]]
end


to fuga-leoes
  let hienas-esquerda count hienas-on patch-left-and-ahead 1 0
  let hienas-direita count hienas-on patch-right-and-ahead 1 0
  let hienas-frente count hienas-on patch-ahead 1


  if hienas-esquerda >= 2 [
    rt 90
    fd 1
    set energia energia - 2
    show "fugi"
  ]
  if hienas-direita >= 2 [
    lt 90
    fd 1
    set energia energia - 2
    show "fugi"
  ]
  if (hienas-frente >= 2 or (hienas-esquerda >= 1 and hienas-direita >= 1)) [
    bk 1
    set energia energia - 3
    show "fugi"
  ]
  if (hienas-esquerda >= 1 and hienas-frente >= 1 and hienas-direita = 0) [
    rt 90
    fd 1
    set energia energia - 5
    bk 1
    show "fugi"
  ]
  if (hienas-direita >= 1 and hienas-frente >= 1 and hienas-esquerda = 0) [ ; Move-se para a esquerda, depois para trás
    lt 90
    fd 1
    set energia energia - 5
    bk 1
    show "fugi"
  ]
  if (hienas-esquerda >= 1 and hienas-direita >= 1 and hienas-frente >= 1) [ ; Move-se duas células para trás
    bk 2
    set energia energia - 4
    show "fugi"
  ]
end



to moveH
  ask hienas [
    let cor_frente [pcolor] of patch-ahead 1
    let cor_esquerda [pcolor] of patch-left-and-ahead 90 1
    let cor_direita [pcolor] of patch-right-and-ahead 90 1

    if reproducao? and count leoes != 0 [reproduzir-hienas]

      ifelse count leoes in-radius 1 = 1 and agrupamento > 1
      [
        let descanso-leao [descanso] of one-of leoes in-radius 1
        if descanso = 0
        [
          let energia-leao [energia] of one-of leoes in-radius 1
          set energia energia - percL * energia-leao
          ask leoes in-radius 1[
            die
            show "morreu"]
        ]
      ]
      [
        ifelse cor_frente = red or cor_frente = brown
        [
          if cor_frente = brown
          [
            fd 1
            set energia energia + energiaAlimento
            ask patch-here [
              set pcolor black
            ]

            ask one-of patches with [pcolor = black] [set pcolor brown]

          ]
          if cor_frente = red
          [
            fd 1
            set energia energia + energiaAlimento
            ask patch-here [
              set pcolor brown
            ]
          ]
        ]
        [
          ifelse cor_esquerda = red or cor_esquerda = brown
          [
            rt 270
            set energia energia - 1

          ]
          [
            ifelse cor_direita = red or cor_direita = brown
            [
              rt 90
              set energia energia - 1
            ]
            [
              ifelse cor_frente != red and cor_frente != brown
              [
                fd 1
                set energia energia - 1
              ]
              [
                set energia energia - 1
              ]
            ]
          ]
        ]

  ]]
end
to reproduzir-leoes
  if random-float 100 < reproducao_leoes[
    set energia (energia / 2)
    hatch 1 [rt random-float 360 fd 1]
  ]
end

to reproduzir-hienas
  if random-float 100 < reproducao_hienas [
    set energia (energia / 2)
    hatch 1 [rt random-float 360 fd 1]
  ]
end
to check-agrupa
  ask hienas [
    ifelse any? other hienas in-radius 1 [
      set color orange
      set agrupamento count hienas in-radius 1
    ] [
      set color grey
      set agrupamento 1
    ]
  ]
end

to display-labels
  ask turtles [ set label "" ]
  if show-energy? [
    ask turtles [set label round energia ]]

end

to ver-morte
  ask leoes
  [
    if energia <= 0
    [ die ]
  ]

  ask hienas
  [
    if energia <= 0
    [ die ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
713
514
-1
-1
15.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
0
10
63
45
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
0
90
172
123
nleao
nleao
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
0
46
172
79
nhienas
nhienas
0
100
97.0
1
1
NIL
HORIZONTAL

BUTTON
141
12
204
45
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
0
133
172
166
qenergia
qenergia
0
100
100.0
1
1
NIL
HORIZONTAL

MONITOR
79
411
136
456
leoes
count leoes
17
1
11

MONITOR
0
408
57
453
hienas
count hienas
17
1
11

SLIDER
0
179
92
212
penergL
penergL
0
1
0.0
0.1
1
NIL
HORIZONTAL

SLIDER
103
179
199
212
penergH
penergH
0
1
0.5
0.1
1
NIL
HORIZONTAL

PLOT
724
10
924
160
Animais
Turtles
Ticks
0.0
100.0
0.0
100.0
false
true
"" ""
PENS
"Leoes" 1.0 0 -4079321 true "" "plot count leoes"
"Hienas" 1.0 0 -12895429 true "" "plot count hienas"

SLIDER
0
221
172
254
energiaAlimento
energiaAlimento
0
50
50.0
1
1
NIL
HORIZONTAL

SLIDER
0
263
172
296
percC
percC
0
20
10.0
1
1
NIL
HORIZONTAL

SLIDER
0
302
172
335
percV
percV
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
0
343
172
376
percA
percA
0
5
4.0
1
1
NIL
HORIZONTAL

SLIDER
715
341
887
374
tempo_descanso
tempo_descanso
0
100
50.0
1
1
NIL
HORIZONTAL

SWITCH
719
219
844
252
reproducao?
reproducao?
0
1
-1000

SLIDER
714
261
886
294
reproducao_leoes
reproducao_leoes
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
712
301
884
334
reproducao_hienas
reproducao_hienas
0
10
6.0
1
1
NIL
HORIZONTAL

SWITCH
718
178
852
211
show-energy?
show-energy?
0
1
-1000

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="teste1" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5000"/>
    <metric>count turtles</metric>
    <metric>count leoes</metric>
    <metric>count hienas</metric>
    <enumeratedValueSet variable="percC">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percV">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percA">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tempo_descanso">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergH">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energiaAlimento">
      <value value="26"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nhienas">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="qenergia">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergL">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nleao">
      <value value="40"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="teste2" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <metric>count turtles</metric>
    <metric>count leoes</metric>
    <metric>count hienas</metric>
    <enumeratedValueSet variable="percC">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percV">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percA">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tempo_descanso">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergH">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energiaAlimento">
      <value value="26"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nhienas">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="qenergia">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergL">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nleao">
      <value value="20"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="teste4" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="7000"/>
    <metric>count turtles</metric>
    <metric>count leoes</metric>
    <metric>count hienas</metric>
    <enumeratedValueSet variable="percC">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percV">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percA">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tempo_descanso">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergH">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energiaAlimento">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nhienas">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="qenergia">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergL">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nleao">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="teste3" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <metric>count turtles</metric>
    <metric>count leoes</metric>
    <metric>count hienas</metric>
    <enumeratedValueSet variable="percC">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percV">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percA">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tempo_descanso">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergH">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energiaAlimento">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nhienas">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="qenergia">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergL">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nleao">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="teste5" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="3000"/>
    <metric>count turtles</metric>
    <metric>count leoes</metric>
    <metric>count hienas</metric>
    <enumeratedValueSet variable="percC">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percV">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tempo_descanso">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergH">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energiaAlimento">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nhienas">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="qenergia">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergL">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nleao">
      <value value="20"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="teste7" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>count turtles</metric>
    <metric>count hienas</metric>
    <metric>count leoes</metric>
    <enumeratedValueSet variable="percV">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-energy?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percA">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energiaAlimento">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergH">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproducao_leoes">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproducao_hienas">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nleao">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percC">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproducao?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tempo_descanso">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nhienas">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="qenergia">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergL">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="teste8" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="400"/>
    <metric>count turtles</metric>
    <metric>count hienas</metric>
    <metric>count leoes</metric>
    <enumeratedValueSet variable="percV">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-energy?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percA">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energiaAlimento">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergH">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproducao_leoes">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproducao_hienas">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nleao">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percC">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproducao?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tempo_descanso">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nhienas">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="qenergia">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergL">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="teste9" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1000"/>
    <metric>count turtles</metric>
    <metric>count hienas</metric>
    <metric>count leoes</metric>
    <enumeratedValueSet variable="percV">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-energy?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percA">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="energiaAlimento">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergH">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproducao_leoes">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproducao_hienas">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nleao">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="percC">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproducao?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tempo_descanso">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nhienas">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="qenergia">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="penergL">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
