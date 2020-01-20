

void mouseDragged() {  //you can drag the pulleys or the handle

    //imagine if... your mouse is a taxi and the item you are moving is a passenger -> you can only move one thing at a time

    if (pulleyOccupied) { //if my mouse is holding a pulley
        passenger.drag(mouseX, mouseY);

        //
    } else if (handleOccupied && (150 < mouseY && mouseY < height)) { //if i am holding the handle

        if (systemValid && ma == 1) {//if the pulley system is complete, the weight will go up when the handle is pulled down

            handle.drag(handle.initX, mouseY);
            weight.drag(weight.position.x, 1000 + 100 - mouseY);
            weight.appliedForce = weight.newtons;
        } else if (systemValid && ma == 2) { //if the findMA function determines that the mechanical advantage of the system has a value of 2

            handle.drag(handle.initX, mouseY);
            weight.drag(weight.position.x, 1000  - mouseY/2); //since ma = 2, the distance the weight travels is twice as much as the handle
            weight.appliedForce = weight.newtons/2; //but half as much force is required to lift it
        }

        //
    } else if (weightOccupied) { 
        weight.drag(mouseX, weightY); //can only move it sideways 
        
        //
    } else if (!pulleyOccupied) { //not holding a pulley, check if your mouse is applicable to hold one  
        for (Pulley i : pulleys) {
            if (mouseOnPulley(i)) { //if the mouse is on a pulley 
                pulleyOccupied = true; 
                passenger = i; 
                break;
            }
        } //see if you can hold a weight
        if ((weight.position.x - weight.weightWidth/2 < mouseX && mouseX < weight.position.x + weight.weightWidth/2) && (weight.position.y - weight.weightHeight/2 < mouseY && mouseY < weight.position.y + weight.weightHeight/2)) { 
            weightOccupied = true;
        }
    }  
    if (!handleOccupied) { //or a handle

        if (mouseOnHandle()) {
            handleOccupied = true;

            systemValid = false; //default values
            weightAttachedToPulley = false;
            ma = 1;
            findMA(ropes.get(0), pulleys.get(0), "right", false); //right before the handle is pulled down
        }
    }
}

void mouseReleased() { //this is basically the trashcan function, if we 'dropped' a pulley in the trash, remove the trash and the pulleys


    handle.drag(handle.initX, handle.initY);
    handleOccupied = false;
    weight.appliedForce = 0;
    weight.drag(weight.position.x, weightY);

    if (pulleyOccupied) {

        if ((width - 200 - 2* trashWidth < mouseX && mouseX < width - 200) && (0 < mouseY && mouseY < 2* trashWidth) ) { // pulley goes to trashcan
            pulleys.remove(pulleys.indexOf(passenger));

            if (passenger.connectLeft.boolConnectedRope) { // ropes attached to the pulley get deleted too

                deleteRope(passenger.connectLeft.connectedRope);
            } 
            if (passenger.connectRight.boolConnectedRope) {

                deleteRope(passenger.connectRight.connectedRope);
            } 
            if (passenger.connectTop.boolConnectedRope) {
                deleteRope(passenger.connectTop.connectedRope);
            } 
            if (passenger.connectBottom.boolConnectedRope) {
                deleteRope(passenger.connectBottom.connectedRope);
            }
        } else if (pulleyToHook()) { //snap functionality
        } else if (pulleyToWeight()) {
        }
    } else if (weightToHook()) {
    }

    pulleyOccupied = false;
    weightOccupied = false;
    systemValid = false; 
    weightAttachedToPulley = false;
    
    ma = 1;
    findMA(ropes.get(0), pulleys.get(0), "right", false); //now see if the modifications that you made is a valid pulley system
}


void mouseClicked() { //you can click on a connector to start a rope, and click on a different connector to establish a rope connection to there

    if (holdingRope) {
        for (Hook i : hooks) {
            if (mouseOnHook(i, true)) { //this function  also updates the occupancy state of the hook
                holdingRope = false;
                break;
            }
        }
        for (Pulley i : pulleys) {
            if (mouseOnPulleyConnector(i, true)) {
                holdingRope = false;

                break;
            }
        }
        if (mouseOnWeightConnector(true)) {
            holdingRope = false;
        }
        //if i am still holding a rope, it means that i have clicked on an empty space, so delete my rope and reset the connections made with it
        if (holdingRope) { 
            Rope a = ropes.get(ropes.size()-1);
            deleteRope(a);
        }
    } else if (!holdingRope) { //if we clicked on something when we aren't holding anything

        //establish a new connection, first check which connector and for which object the mouse has clicked on
        for (Hook i : hooks) { //if we clicked on a hook, we will attach a rope to it
            if (mouseOnHook(i, false)) { //if true, this function also attaches a rope to the hook
                holdingRope = true;
                break;
            }
        }
        for (Pulley i : pulleys) {
            if (mouseOnPulleyConnector(i, false)) { 
                holdingRope = true;
                break;
            }
        }
        if (!weight.connectTop.occupied) { //very very very very weird, if i put these two if-conditions together - > if (mouseOnWeightConnector(false) && !weight.connectTop.occupied) {}, the computer gives the wrong result, something is wrong with !weight.connectTop.occupied

            if (mouseOnWeightConnector(false)) { 

                holdingRope = true;
            }
        }
    }
}


void keyPressed() { //pressing any key will delete the last rope connection we established

    int lastIndex = ropes.size() -1;

    if (lastIndex > 0) {
        Rope a = ropes.get(lastIndex);
        deleteRope(a);
    }
}
