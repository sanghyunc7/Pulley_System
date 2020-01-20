boolean weightToHook() { //checks if the weight can attach to a hook

    for (int i=0; i< width; i+=50) { //if true, then 'snap' the weight to the applicable hook
        if (abs(weight.position.x - i) < 25) {

            weight.drag(i, weight.position.y);
            return true;
        }
    }
    return false;
}


boolean pulleyToHook() { //checks if the pulley can attach to a hook

    //we know which pulley we are holding - passenger
    //find which hook it is on

    for (Hook i : hooks) {

        if (pow(passenger.connectTop.x - i.connectTip.x, 2) + pow(passenger.connectTop.y - i.connectTip.y, 2) < pow(connectRadius, 2)) { //check for both connectTop and connectBottom

            passenger.drag(i.connectTip.x, i.connectTip.y + radius); //update position

            i.connectTip.occupied = true; //update the state of the connectors 
            i.connectTip.connectedPulley = passenger;
            i.connectTip.boolConnectedPulley = true;

            passenger.connectTop.occupied = true;
            passenger.connectTop.boolConnectedHook = true;
            passenger.connectTop.connectedHook = i;

            return true;
        } else if (pow(passenger.connectBottom.x - i.connectTip.x, 2) + pow(passenger.connectBottom.y - i.connectTip.y, 2) < pow(connectRadius, 2)) { //check for both connectTop and connectBottom
            passenger.drag(i.connectTip.x, i.connectTip.y - radius);

            i.connectTip.occupied = true;
            i.connectTip.connectedPulley = passenger;
            i.connectTip.boolConnectedPulley = true;

            passenger.connectBottom.occupied = true;
            passenger.connectBottom.boolConnectedHook = true;
            passenger.connectBottom.connectedHook = i;
            return true;
        }
    }
    return false;
}


boolean pulleyToWeight() { ////checks if the pulley can attach to the weight

    if (pow(passenger.connectBottom.x - weight.connectTop.x, 2) + pow(passenger.connectBottom.y - weight.connectTop.y, 2) < pow(radius, 2)) {

        passenger.drag(weight.connectTop.x, weight.connectTop.y - radius);       

        weight.connectTop.occupied = true;  //update the state of the connectors 
        weight.connectTop.connectedPulley = passenger;
        weight.connectTop.boolConnectedPulley = true;

        passenger.connectBottom.occupied = true;
        passenger.connectBottom.boolConnectedWeight = true;

        return true;
    }
    return false;
}
