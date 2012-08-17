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

declare function local:generate-teeth($arc as element(cone-sphere:arc), $outside as xs:boolean, 
    $arc-angle as xs:double, $tab-width as xs:integer, $tooth-width as xs:integer) as element(svg:g) {
    let $r := $arc/@radius
    let $fractional-teeth := ($arc-angle * $r - $tab-width div 2) div $tooth-width
    let $num-teeth := xs:integer($fractional-teeth)
    let $scale := $fractional-teeth div $num-teeth
    let $d-angle := $arc-angle div $num-teeth
    return 
    <g>
    {
    for $i in (1 to $num-teeth)
        let $a := ($i - 0.5) * $d-angle
        let $x := $r * math:cos($a)
        let $y := $r * math:sin($a)
        return <use xlink:href="#tooth" 
            transform="{svg-utils:transform((svg-utils:translate($x, $y), 
            svg-utils:rotate(svg-utils:rad-to-deg($a)),
            svg-utils:rotate(90)))}" />
    }
    </g>
};

let $tooth-width := 100
let $tooth-height := 50

let $tab-width := 100
let $tab-height := 100

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
let $svg-height := $center-height + $max-radius * 2

return
<svg version="1.1"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     baseProfile="full" width="{$svg-width}" height="{$svg-height}">     
     <style type="text/css">
        .guide {{ stroke: red; fill: none; }}
        .valley-fold {{ stroke: black; stroke-dasharray: 9, 5; fill:none; }}
        .mountain-fold {{ stroke: black; stroke-dasharray: 9, 5, 3, 5; fill: none; }}
        .cut {{ stroke:black; fill: none; }}
     </style>
    <defs>
        <path id="tooth" d="M 0,0 q 35,0 25,-25 -10,-25 25,-25 35,0 25,25 -10,25 25,25" />                
        <path id="tab" d="M 100,0 l 0,25 -50,0 0,-25 -50,50 50,50 0,-25 50,0 0,25" />
        <path id="slot" d="M 50,0 l 50,0 0,100 -50,0 M 50,25 l 0,50" />
    </defs>
    {
    for $i in (1 to $num-cones)
        let $cone-id := concat("cone-", $i)
        let $center := 2 * ($i - 1) + 1 = $num-cones
        return
        {
        if ($center)
        then
        {
            let $width := $center-width
            let $height := $center-height
            
            let $fractional-teeth := ($width - $tab-width div 2) div $tooth-width
            let $num-teeth := xs:integer($fractional-teeth)
            let $tooth-scale := $fractional-teeth div $num-teeth
            let $tooth-scaled-width := $tooth-width * $tooth-scale
            let $tooth-scaled-height := $tooth-height * $tooth-scale
                        
            return
            <g id="{$cone-id}" transform="{svg-utils:translate($tab-width div 2, $tooth-scaled-height)}">
                <rect class="guide" x="0" y="0" 
                    width="{$width}" height="{$height}" />
                    <g class="cut">
                        <g transform="{svg-utils:transform((svg-utils:scale(1, $side-length div $tab-height), 
                            svg-utils:translate(-$tab-width div 2)))}">
                            <use xlink:href="#tab"/>
                            <use xlink:href="#slot" transform="{svg-utils:translate($width)}"/>
                        </g>
                        <g transform="{svg-utils:translate($tab-width div 2)}">
                        {for $i in (0 to 1)
                            let $y := $i * $center-height
                            return 
                            <g transform="{svg-utils:transform((svg-utils:translate(0, $y), 
                                svg-utils:scale($tooth-scale)))}">
                            {for $j in (1 to $num-teeth)
                                let $x := ($j - 1) * $tooth-width
                                return <use xlink:href="#tooth" 
                                    transform="{svg-utils:transform((svg-utils:translate($x), 
                                    svg-utils:scale(1, 1 - 2 * $i)))}" />
                            }
                            </g>
                        }
                        </g>
                   </g>
            </g>
        }
        else 
        {
            let $center-x := $max-radius + (if ($i > $n) then 2 * $max-radius else 0)
            let $center-y := $max-radius + $center-height
            return
            <g id="{$cone-id}" transform="{svg-utils:translate($center-x, $center-y)}">
            {
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
            
            let $d := if ($is-cone) then {
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
            let $tab-start-translate := svg-utils:translate(-$tab-width div 2)
            let $tab-scale := svg-utils:scale(1, $side-length div $tab-height)
            let $tabs := if ($is-cone) then <g/>
            else 
            <g>
                <use xlink:href="#tab" 
                    transform="{svg-utils:transform((svg-utils:translate($arc/@start-x, $arc/@start-y), 
                    svg-utils:rotate(90), $tab-scale, $tab-start-translate))}"/>
                <use xlink:href="#slot" 
                    transform="{svg-utils:transform((svg-utils:translate($arc/@end-x, $arc/@end-y),
                    svg-utils:rotate(svg-utils:rad-to-deg($arc-angle)+90), $tab-scale,
                    $tab-start-translate))}"/>
            </g>
            
            let $teeth := if ($is-cone) 
            then <g>{local:generate-teeth($arc, true(),$arc-angle,$tab-width,$tooth-width)}</g> 
            else 
            <g>
            {local:generate-teeth($arc, true(),$arc-angle,$tab-width,$tooth-width)} 
            {local:generate-teeth($inner-arc, false(),$arc-angle,$tab-width,$tooth-width)}
            </g>
            return
            <g>
                <path class="guide" d="{$d}" />
                <g class="cut">
                    {$tabs}
                    {$teeth}
                </g>
             </g>
         }
         </g>
      }
      }
      }
</svg>