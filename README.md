# DQN-demo

## Description

Simple DQN demo using nasal programming language.

DQN data will be stored in file: agent.dat

## Requirements

Nasal interpreter version 11.0. See [here](#what-is-nasal). Better use the version on branch master, or download latest zip.

Need to add path of nasal interpreter to environment path. But i copy the `std` directory here so it could run correctly without adding path.

## Execute

Use this command to train the model:

> nasal dqn.nas

And use this command to test the model:

> nasal test.nas

## What is Nasal?

[Nasal](http://wiki.flightgear.org/Nasal_scripting_language) is a programming language used in famous flight simulator [FlightGear](https://www.flightgear.org/).It's quite simple and easy to learn and use.

I wrote an stack-based bytecode interpreter that can run this language out of flightgear environment efficiently.

Click [HERE](https://github.com/ValKmjolnir/Nasal-Interpreter) to get the nasal-interpreter source code on github.

Click [HERE](https://gitee.com/valkmjolnir/Nasal-Interpreter) to get the nasal-interpreter source code on gitee.

Click [HERE](http://wiki.flightgear.org/Nasal_scripting_language) to get the information and usage of this programming language.
