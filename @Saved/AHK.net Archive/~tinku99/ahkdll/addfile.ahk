second(z)
{
global dynamicFunction
msgbox, second
dynamicFunction = third
return
}

third(z = "third")
{
global dynamicFunction
msgbox, third
dynamicFunction = fourth
return
}

second("second")
