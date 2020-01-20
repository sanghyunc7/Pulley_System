void reset() { //if the user clicks on the reset button, all objects that the user interacted with is removed

    for (int i=pulleys.size()-1; i>0; i--) {
        pulleys.remove(i);
    }
    for (int i=ropes.size()-1; i>0; i--) {
        ropes.remove(i);
    }
    for (int i=hooks.size()-1; i>0; i--) {
        hooks.remove(i);
    }
    for (int i=50; i<width - 400; i+=50) {
        hooks.add(new Hook(i, 0, true));
        hooks.add(new Hook(i, height, false)); //putting hooks onto the top and bottom of the screen
    }

    fixedSystem(); 

    weight = new Weight(width - 500, weightY);

    holdingRope = false; 
    pulleyOccupied = false;
    weightOccupied = false;
    handleOccupied = false;
    systemValid = false;
    weightAttachedToPulley = false;

    arrayIteration = 0;
    round = 0;
    ma = 1;

    passenger = pulleys.get(0);
    passenger.connectLeft.occupied = false;
    passenger.connectLeft.boolConnectedRope = false;
    passenger.connectBottom.occupied = false;
    passenger.connectBottom.boolConnectedRope = false;
}


void resetPulleyConnection(Pulley i) { //if a pulley is dragged into a trash can, delete the pulley, the ropes attached to it, and reset the connection states those ropes may have with another object

    if (i.connectTop.boolConnectedHook) { //if the pulley was attached to a hook, reset the states of the hook and the pulley's connectors
        i.connectTop.boolConnectedHook = false;
        i.connectTop.occupied = false;

        Hook hook =  i.connectTop.connectedHook;
        hook.connectTip.boolConnectedPulley = false;
        hook.connectTip.occupied = false;
    } 
    if (i.connectBottom.boolConnectedHook) { //check the bottom 
        i.connectBottom.boolConnectedHook = false;
        i.connectBottom.occupied = false;

        Hook hook =  i.connectBottom.connectedHook;
        hook.connectTip.boolConnectedPulley = false;
        hook.connectTip.occupied = false;
    }  

    if (i.connectBottom.boolConnectedWeight) { //if the pulley was attached to the weight, reset the states of the weight and the pulley's connectors

        i.connectBottom.boolConnectedWeight = false;
        i.connectBottom.occupied = false;

        weight.connectTop.boolConnectedPulley = false;
        weight.connectTop.occupied = false;
    }
}


void deleteRope(Rope a) {  //this function deletes the rope and updates the connection states associated with it

    if (a.connectStart.boolConnectedPulley) { 

        Pulley pulley = a.connectStart.connectedPulley;
        deleteRopeFromPulley(a, pulley); 
        //
    } else if (a.connectStart.boolConnectedHook) {

        Hook hook = a.connectStart.connectedHook;
        deleteRopeFromHook(hook);
        //
    } else if (weight.connectTop.boolConnectedRope) { 

        if (weight.connectTop.connectedRope.equals(a)) {
            deleteRopeFromWeight(); 
        }
    }


    if (a.connectEnd.boolConnectedPulley) { //if at the start of the rope 

        Pulley pulley = a.connectEnd.connectedPulley;
        deleteRopeFromPulley(a, pulley);
        //
    } else if (a.connectEnd.boolConnectedHook) {

        Hook hook = a.connectEnd.connectedHook;
        deleteRopeFromHook(hook);
        //
    } else if (weight.connectTop.boolConnectedRope) {
        if (weight.connectTop.connectedRope.equals(a)) {
            deleteRopeFromWeight();
        }
    }

    ropes.remove(ropes.indexOf(a));
    holdingRope = false;
}


void deleteRopeFromPulley (Rope a, Pulley pulley) { //updates the pulley connections to false
    if (pulley.connectLeft.boolConnectedRope) {
        if (pulley.connectLeft.connectedRope.equals(a)) { 
            pulley.connectLeft.boolConnectedRope = false;
            pulley.connectLeft.occupied = false;
        }
    }  
    if (pulley.connectRight.boolConnectedRope) {
        if (pulley.connectRight.connectedRope.equals(a)) {
            pulley.connectRight.boolConnectedRope = false;
            pulley.connectRight.occupied = false;
        }
    }  
    if (pulley.connectTop.boolConnectedRope) {
        if (pulley.connectTop.connectedRope.equals(a)) {
            pulley.connectTop.boolConnectedRope = false;
            pulley.connectTop.occupied = false;
        }
    }  
    if (pulley.connectBottom.boolConnectedRope) {
        if (pulley.connectBottom.connectedRope.equals(a)) {
            pulley.connectBottom.boolConnectedRope = false;
            pulley.connectBottom.occupied = false;
        }
    }
}

void deleteRopeFromHook(Hook hook) {

    hook.connectTip.boolConnectedRope = false;
    hook.connectTip.occupied = false;
}

void deleteRopeFromWeight() { 

    weight.connectTop.boolConnectedRope = false;
    weight.connectTop.occupied = false;
}
