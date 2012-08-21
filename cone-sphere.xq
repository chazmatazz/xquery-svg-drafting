(: Approximation of sphere with cone slices and interlocking tabs and teeth :)
declare default element namespace "http://www.w3.org/2000/svg";

declare namespace svg = "http://www.w3.org/2000/svg";

declare namespace xlink = "http://www.w3.org/1999/xlink";

declare namespace cone-sphere = "http://www.charlesdietrich.com/cone-sphere";

import module namespace math = "http://www.w3.org/2005/xpath-functions/math";

import module namespace svg-utils="http://www.charlesdietrich.com/svg-utils" at "svg-utils.xq";

declare function local:arc($radius as xs:double, $arc-angle as xs:double) as element(cone-sphere:arc) {
    <cone-sphere:arc radius="{$radius}" start-x="{$radius * math:cos(0)}" start-y="{$radius * math:sin(0)}"
                end-x="{$radius * math:cos($arc-angle)}" end-y="{$radius * math:sin($arc-angle)}" />
};

declare function local:get-pts($pt-str as xs:string) as xs:integer* {
    let $pts := tokenize($pt-str, " ")
    return {for $pt in $pts
        let $cs := tokenize($pt, ",")
        return {for $c in $cs
            return xs:integer($c)}}
};

let $tab-width := 100
let $tab-height := 50

let $tab-str := "0,0 35,0 35,25 25,25 50,50 75,25 65,25 65,0 100,0"
let $tab-pts := local:get-pts($tab-str)

let $slot-str := "35,25 65,25"
let $slot-pts := local:get-pts($slot-str)

let $end-tab-angle := math:pi() div 8

let $a90 := math:pi() div 2

let $inner-radius := 200
let $n := 5
let $num-cones := 2 * $n + 1
let $num-sides := 2 * $num-cones
let $dtheta := 2 * math:pi() div $num-sides
let $outer-radius := $inner-radius div math:cos($dtheta div 2) 
let $side-length := 2 * $inner-radius * math:tan($dtheta div 2)

let $center-width := xs:integer(2 * math:pi() * $outer-radius)
let $center-height := xs:integer($side-length)

let $max-radius := $center-width * 2(: TODO: calculate properly :)

let $svg-width := $max-radius * 4
let $svg-height := $center-height + $max-radius * 4

return
<svg version="1.1"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     baseProfile="full" width="{$svg-width}" height="{$svg-height}">     
     <style type="text/css">
        .guide {{ fill: red; }}
        .valley-fold {{ stroke: black; stroke-dasharray: 9, 5; fill:none; }}
        .mountain-fold {{ stroke: black; stroke-dasharray: 9, 5, 3, 5; fill: none; }}
        .cut {{ stroke:black; fill: none; }}
     </style>
    {
    for $i in (1 to $num-cones)
        let $cone-id := concat("cone-", $i)
        let $center := 2 * ($i - 1) + 1 = $num-cones
        return
        {
        if ($center)
        then
        {
            let $fractional-tabs := $center-width div $tab-width
            let $num-tabs := xs:integer($fractional-tabs)
            let $tab-scale := $fractional-tabs div $num-tabs
            
            let $width := $center-width div $tab-scale
            let $height := $center-height div ($side-length div $tab-width)
            
            (:
            move to upper left of guide
            draw top
            draw right border
            draw lower border
            draw left tab
            draw top slots L->R
            draw bottom slots L->R
            draw right slot
            :)
            let $d := svg-utils:path((svg-utils:M($tab-height, $tab-height),
                svg-utils:H($tab-height + $width),
              svg-utils:M($tab-height + $width, $tab-height),
              svg-utils:V($tab-height + $height),
              svg-utils:H($tab-height),
              svg-utils:L(({for $i in (1 to xs:integer(count($tab-pts) div 2))
                        let $x := $tab-pts[2 * $i - 1]
                        let $y := $tab-pts[2 * $i]
                        let $tx := $tab-height + $x * math:cos(-$a90) + $y * math:sin(-$a90)
                        let $ty := $tab-height - $x * math:sin(-$a90) + $y * math:cos(-$a90)
                        return
                        ($tx,$ty)})),
              svg-utils:path({for $i in (1 to $num-tabs)
                    return svg-utils:path((svg-utils:M($tab-height + $slot-pts[1] + ($i - 1) * $tab-width,
                              $tab-height + $slot-pts[2]),
                              svg-utils:L($tab-height + $slot-pts[3] + ($i - 1) * $tab-width,
                              $tab-height + $slot-pts[4])))}),
              svg-utils:path({for $i in (1 to $num-tabs)
                    return svg-utils:path((svg-utils:M($tab-height + $slot-pts[1] + ($i - 1) * $tab-width,
                              $tab-height + $height - $slot-pts[2]),
                              svg-utils:L($tab-height + $slot-pts[3] + ($i - 1) * $tab-width,
                              $tab-height + $height - $slot-pts[4])))}),
              svg-utils:path((
                    svg-utils:M(
                    $tab-height + $width + $slot-pts[1] * math:cos(-$a90) + $slot-pts[2] * math:sin(-$a90),
                    $tab-height - $slot-pts[1] * math:sin(-$a90) + $slot-pts[2] * math:cos(-$a90)),
                    svg-utils:L(
                    $tab-height + $width + $slot-pts[3] * math:cos(-$a90) + $slot-pts[4] * math:sin(-$a90),
                    $tab-height - $slot-pts[3] * math:sin(-$a90) + $slot-pts[3] * math:cos(-$a90))))))
            return
            <g id="{$cone-id}" transform="{svg-utils:scale($tab-scale, $side-length div $tab-width)}">
                <rect class="guide" x="{xs:integer($tab-height)}" 
                    y="{xs:integer($tab-height)}" 
                    width="{xs:integer($width)}" 
                    height="{xs:integer($height)}" />
                <path class="cut" d="{$d}" />
            </g>
        }
        else 
        {
            let $center-x := $max-radius + (if ($i > $n) then 2 * $max-radius else 0)
            let $center-y := $max-radius + $center-height + $max-radius * 2 * ($i mod 2) - 1

            let $cone-radii := {
            for $j in (-1 to 0)
                return
                $outer-radius * math:sin($dtheta * ($i + $j))
            }
            let $larger-radius := max($cone-radii)
            let $d-radius := $larger-radius - min($cone-radii)
            
            let $arc-angle := 2 * math:pi() * $d-radius div $side-length
            let $large-arc-flag := if ($arc-angle > math:pi()) then 1 else 0
            let $p := $larger-radius * $side-length div $d-radius
            let $inner-p := $p - $side-length
            
            let $arc := local:arc($p, $arc-angle)
            let $inner-arc := local:arc($inner-p, $arc-angle)
            
            let $is-cone := xs:integer($inner-p) = 0
            
            let $guide-d := if ($is-cone) then {
                 svg-utils:path((svg-utils:M($arc/@start-x, $arc/@start-y), 
                                    svg-utils:A($arc/@radius, $arc/@radius, 
                                    0, $large-arc-flag, 1, 
                                    $arc/@end-x, $arc/@end-y),
                                    svg-utils:L(0,0),
                                    svg-utils:L($arc/@start-x, $arc/@start-y),
                                    svg-utils:Z()))
            } else {
                 svg-utils:path((svg-utils:M($arc/@start-x, $arc/@start-y),
                                    svg-utils:A($arc/@radius, $arc/@radius, 
                                    0, $large-arc-flag, 1, 
                                    $arc/@end-x, $arc/@end-y),
                                    svg-utils:L($inner-arc/@end-x, $inner-arc/@end-y),
                                    svg-utils:A($inner-arc/@radius, $inner-arc/@radius,
                                    0, $large-arc-flag, 0,$inner-arc/@start-x,$inner-arc/@start-y),
                                    svg-utils:L($arc/@start-x,$arc/@start-y),
                                    svg-utils:Z()))
            }

            let $cut-d := if ($is-cone) then {
                let $fractional-tabs := $p * $arc-angle div $tab-width
                let $num-tabs := xs:integer($fractional-tabs)
                let $tab-scale := $fractional-tabs div $num-tabs
                let $d-tab-angle := $arc-angle div $num-tabs
                return
                (: draw tabs then pie slice :)
                svg-utils:path((svg-utils:M($arc/@start-x, $arc/@start-y),
                    svg-utils:L({for $i in (1 to $num-tabs)
                         let $tab-start-angle := ($i - 1) * $d-tab-angle
                         for $j in (1 to xs:integer(count($tab-pts) div 2))
                            let $x := $tab-pts[2 * $j - 1]
                            let $y := $tab-pts[2 * $j]
                            let $rot-x := $x * math:cos($a90) + $y * math:sin($a90)
                            let $rot-y := $x * math:sin($a90) - $y * math:cos($a90)
                            let $x-radius := $rot-x + $arc/@radius
                            let $y-angle := $tab-start-angle + $d-tab-angle * $rot-y div $tab-width
                            let $tx := $x-radius * math:cos($y-angle)
                            let $ty := $x-radius * math:sin($y-angle)
                            return
                            ($tx,$ty)}),
                            svg-utils:L(0,0),
                            svg-utils:L($arc/@start-x, $arc/@start-y),
                            svg-utils:Z()))
            } else {
                let $fractional-tabs := $p * $arc-angle div $tab-width
                let $num-tabs := xs:integer($fractional-tabs)
                let $tab-scale := $fractional-tabs div $num-tabs
                let $d-tab-angle := $arc-angle div $num-tabs
                
                let $fractional-slots := $inner-p * $arc-angle div $tab-width
                let $num-slots := xs:integer($fractional-slots)
                let $slot-scale := $fractional-slots div $num-slots
                let $d-slot-angle := $arc-angle div $num-slots
                
                return
                (: 
                draw outer tabs counterclockwise
                draw cap
                draw inner arc
                draw end tab
                draw inner slots 
                draw end slot
                :)
                svg-utils:path((svg-utils:M($arc/@start-x, $arc/@start-y),
                    svg-utils:L({for $i in (1 to $num-tabs)
                         let $tab-start-angle := ($i - 1) * $d-tab-angle
                         for $j in (1 to xs:integer(count($tab-pts) div 2))
                            let $x := $tab-pts[2 * $j - 1]
                            let $y := $tab-pts[2 * $j]
                            let $rot-x := $x * math:cos($a90) + $y * math:sin($a90)
                            let $rot-y := $x * math:sin($a90) - $y * math:cos($a90)
                            let $x-radius := $rot-x + $arc/@radius
                            let $y-angle := $tab-start-angle + $d-tab-angle * $rot-y div $tab-width
                            let $tx := $x-radius * math:cos($y-angle)
                            let $ty := $x-radius * math:sin($y-angle)
                            return
                            ($tx,$ty)}),
                     svg-utils:L($inner-arc/@end-x, $inner-arc/@end-y),
                     svg-utils:A($inner-arc/@radius, $inner-arc/@radius, 0, $large-arc-flag, 0,
                            $inner-arc/@start-x, $inner-arc/@start-y),
                     svg-utils:L({for $i in (1 to xs:integer(count($tab-pts) div 2))
                            let $x := $tab-pts[2 * $i - 1]
                            let $y := $tab-pts[2 * $i]
                            let $rot-x := -$x * math:cos(0) - $y * math:sin(0)
                            let $rot-y := $x * math:sin(0) - $y * math:cos(0)
                            let $x-radius := $rot-x * $side-length div $tab-width + $arc/@radius
                            let $y-angle := $end-tab-angle * $rot-y div $tab-width
                            let $tx := $x-radius * math:cos($y-angle)
                            let $ty := $x-radius * math:sin($y-angle)
                            return
                            ($tx,$ty)}),
                     ({for $i in (1 to $num-slots)
                            let $slot-start-angle := $i * $d-slot-angle
                            let $t-pts := {for $j in (1 to xs:integer(count($slot-pts) div 2))
                                let $x := $slot-pts[2 * $j - 1]
                                let $y := $slot-pts[2 * $j]
                                let $rot-x := $x * math:cos($a90) + $y * math:sin($a90)
                                let $rot-y := -$x * math:sin($a90) + $y * math:cos($a90)
                                let $x-radius := $rot-x + $inner-arc/@radius
                                let $y-angle := $slot-start-angle + $d-slot-angle * $rot-y div $tab-width
                                let $tx := $x-radius * math:cos($y-angle)
                                let $ty := $x-radius * math:sin($y-angle)
                                return
                                ($tx,$ty)}
                            return 
                            (svg-utils:M($t-pts[1], $t-pts[2]),
                            svg-utils:L($t-pts[3], $t-pts[4]))})))
            }
            
            return
            <g id="{$cone-id}" transform="{svg-utils:translate($center-x, $center-y)}">
                <path class="guide" d="{$guide-d}" />
                <path class="cut" d="{$cut-d}" />
            </g>
      }
      }
      }
</svg>