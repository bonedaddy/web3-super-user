#! /bin/bash

# used to compile a new nethermind build

cd nethermind/src/Nethermind
dotnet build Nethermind.sln -c Release -o ~/nethermind-build
sudo cp -r /home/darkadmin/nethermind-build /var/lib
