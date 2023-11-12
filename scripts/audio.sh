#!/bin/bash

chosen=$(pactl list short sinks | cut -f2 | sort | fzf)

pactl set-default-sink $chosen

