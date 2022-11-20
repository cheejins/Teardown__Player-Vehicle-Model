#!/bin/bash

prefab_folders=(
"Agro pack"
"Avertnus's ragdoll pack"
"Darren's ragdoll pack"
"EVGSTORE's ragdoll pack"
"FoxyPlayzYT's ragdoll pack"
"idixticlol's ragdoll pack"
"Jacob's ragdoll pack"
"Morvex's ragdoll pack"
"OffensivePDF's ragdoll pack"
"Sitters"
"SnakeyWakey's ragdoll pack"
"Squareblock's ragdoll pack"
)


print_xml () {
    cd "$*"
    pwd
    find -name '*xml*'
    cd ..
}


main () {

    cd "./main/Gore Ragdolls 2/"

    for i in $( echo ${!prefab_folders[@]}); do
        print_xml ${prefab_folders[$i]}
    done

}

main
