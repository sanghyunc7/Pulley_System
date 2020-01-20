boolean mouseOnPulley(Pulley i) { 

    if (pulleys.get(0).equals(i)) { //off limits, the first pulley we stored is used as a special pulley, critical for our findMA function
        return false;
    }
    if ( pow(mouseX - i.position.x, 2) + pow(mouseY - i.position.y, 2) < pow(radius, 2)) { //if my mouse is within a pulley

        resetPulleyConnection(i);
        return true;
    } else return false;
}




boolean mouseOnHook(Hook i, boolean holdingRope) {


    boolean cut = false;

    if (( pow(mouseX - i.connectTip.x, 2) + pow(mouseY - i.connectTip.y, 2) < pow(connectRadius, 2))  && !i.connectTip.occupied ) { //if my mouse is on a hook
        if (!holdingRope) { 

            Rope a = new Rope(i.connectTip.x, i.connectTip.y, mouseX, mouseY);
            a.connectStart.connectedHook = i;
            a.connectStart.boolConnectedHook = true;

            i.connectTip.occupied = true; //update connection states
            i.connectTip.connectedRope = a;
            i.connectTip.boolConnectedRope = true;

            ropes.add(a); //add the new rope to our rope arraylist, the draw() function will draw it the screen
        } else if (holdingRope) { //if true, then update end of rope at the hook's position

            Rope a =  ropes.get(ropes.size()-1); //the last rope in our arraylist is the one we are holding 

            if (a.connectStart.boolConnectedWeight) {
                if (weight.position.x -25 < i.connectTip.x && i.connectTip.x < weight.position.x + 25) { //establish the end of a rope's connection to a hook
                    a.connectEnd.connectedHook = i;
                    a.connectEnd.boolConnectedHook = true;
                    a.connectEnd.set(i.connectTip);

                    i.connectTip.occupied = true;
                    i.connectTip.connectedRope = a;
                    i.connectTip.boolConnectedRope = true;
                  
                }
                cut = true;
            }

            if (!cut) {
                a.connectEnd.connectedHook = i;
                a.connectEnd.boolConnectedHook = true;
                a.connectEnd.set(i.connectTip);

                i.connectTip.occupied = true;
                i.connectTip.connectedRope = a;
                i.connectTip.boolConnectedRope = true;
                
            }
        }
        return true;
    } else
        return false;
}


boolean mouseOnHandle () {

    if ( pow(mouseX - handle.position.x, 2) + pow(mouseY - handle.position.y, 2) < pow(25, 2)) { //if the mosue is within the handle
        return true;
    } else return false;
}


boolean mouseOnPulleyConnector(Pulley i, boolean holdingRope) { 

    boolean perpendicularRequirement = false;
    //revised - each connector now knows which rope is attached to it


    if (!holdingRope) { //if we aren't holding a rope, the rope will start at one of the four connectors, and for now end at the mouse


        if (( pow(mouseX - i.connectLeft.x, 2) + pow(mouseY - i.connectLeft.y, 2) < pow(connectRadius, 2)) && !i.connectLeft.occupied) { //if my mouse is within the pulley's left connector, that connector must also be free from any attachment with other objects


            Rope a = new Rope(i.connectLeft.x, i.connectLeft.y, mouseX, mouseY);
            a.connectStart.connectedPulley = i;
            a.connectStart.boolConnectedPulley = true;

            i.connectLeft.occupied = true;
            i.connectLeft.connectedRope = a;
            i.connectLeft.boolConnectedRope = true;

            ropes.add(a); 

            return true;
        } else if ((pow(mouseX - i.connectRight.x, 2) + pow(mouseY - i.connectRight.y, 2) < pow(connectRadius, 2)) && !i.connectRight.occupied ) { //if my mouse within the right connector


            Rope a = new Rope(i.connectRight.x, i.connectRight.y, mouseX, mouseY);
            a.connectStart.connectedPulley = i;
            a.connectStart.boolConnectedPulley = true;


            i.connectRight.occupied = true;
            i.connectRight.connectedRope = a; //pulley's connectRight is connected to this particular rope
            i.connectRight.boolConnectedRope = true;

            ropes.add(a);

            return true;
        } else if (( pow(mouseX - i.connectTop.x, 2) + pow(mouseY - i.connectTop.y, 2) < pow(connectRadius, 2)) && !i.connectTop.occupied) {

            Rope a = new Rope(i.connectTop.x, i.connectTop.y, mouseX, mouseY);
            a.connectStart.connectedPulley = i;
            a.connectStart.boolConnectedPulley = true;

            i.connectTop.occupied = true;
            i.connectTop.connectedRope = a; 
        
            i.connectTop.boolConnectedRope = true;

            ropes.add(a);

            return true;
        } else if ((pow(mouseX - i.connectBottom.x, 2) + pow(mouseY - i.connectBottom.y, 2) < pow(connectRadius, 2)) && !i.connectBottom.occupied) {

            Rope a = new Rope(i.connectBottom.x, i.connectBottom.y, mouseX, mouseY);
            a.connectStart.connectedPulley = i;
            a.connectStart.boolConnectedPulley = true;

            i.connectBottom.occupied = true;
            i.connectBottom.connectedRope = a; 
            i.connectBottom.boolConnectedRope = true;

            ropes.add(a);

            return true;
        }
    } else if (holdingRope) { //if we are holding a rope, the rope will end at mouse


        if (ropes.get(ropes.size() - 1).connectStart.boolConnectedPulley) { //created this condition to prevent a null pointer error in the next if-statement
            if (ropes.get(ropes.size() - 1).connectStart.connectedPulley.equals(i)) { //if we are trying to attach a rope to the same pulley
                return false;
            }
        }

        if (i.connectBottom.boolConnectedWeight) {
            perpendicularRequirement = true;
        }


        if (( pow(mouseX - i.connectLeft.x, 2) + pow(mouseY - i.connectLeft.y, 2) < pow(connectRadius, 2)) && !i.connectLeft.occupied) { //if my mouse is within a hook

            Rope a =  ropes.get(ropes.size()-1);

            if (perpendicularRequirement && a.connectStart.x != i.connectLeft.x) { //if the rope must be attached perpendicularly
                return false;
            }

            a.connectEnd.connectedPulley = i;
            a.connectEnd.boolConnectedPulley = true;
            a.connectEnd.set(i.connectLeft);

            i.connectLeft.occupied = true;
            i.connectLeft.connectedRope = a;
            i.connectLeft.boolConnectedRope = true;

            return true;
        } else if (( pow(mouseX - i.connectRight.x, 2) + pow(mouseY - i.connectRight.y, 2) < pow(connectRadius, 2)) && !i.connectRight.occupied) {

            Rope a =  ropes.get(ropes.size()-1);

            if (perpendicularRequirement && a.connectStart.x != i.connectRight.x) {
                return false;
            }

            a.connectEnd.connectedPulley = i;
            a.connectEnd.boolConnectedPulley = true;
            a.connectEnd.set(i.connectRight);

            i.connectRight.occupied = true;
            i.connectRight.connectedRope = a;
            i.connectRight.boolConnectedRope = true;

            return true;
        } else if (( pow(mouseX - i.connectTop.x, 2) + pow(mouseY - i.connectTop.y, 2) < pow(connectRadius, 2)) && !i.connectTop.occupied) {

            Rope a =  ropes.get(ropes.size()-1);
            a.connectEnd.connectedPulley = i;
            a.connectEnd.boolConnectedPulley = true;
            a.connectEnd.set(i.connectTop);

            i.connectTop.occupied = true;
            i.connectTop.connectedRope = a;
            i.connectTop.boolConnectedRope = true;

            return true;
        } else if (( pow(mouseX - i.connectBottom.x, 2) + pow(mouseY - i.connectBottom.y, 2) < pow(connectRadius, 2)) && !i.connectBottom.occupied) {

            Rope a =  ropes.get(ropes.size()-1);
            a.connectEnd.connectedPulley = i;
            a.connectEnd.boolConnectedPulley = true;
            a.connectEnd.set(i.connectBottom);

            i.connectBottom.occupied = true;
            i.connectBottom.connectedRope = a;
            i.connectBottom.boolConnectedRope = true;

            return true;
        }
    }

    return false;
} 


boolean mouseOnWeightConnector(boolean holdingRope) { 

    if (pow(mouseX - weight.connectTop.x, 2) + pow(mouseY - weight.connectTop.y, 2) < pow(connectRadius, 2)) {

        if (!holdingRope && !weight.connectTop.occupied) {

            Rope a = new Rope(weight.connectTop.x, weight.connectTop.y, weight.connectTop.x, mouseY); //same procedure as above, create a rope, update connection states, then add the rope to the rope arraylist

            a.connectStart.boolConnectedWeight = true;

            weight.connectTop.occupied = true;
            weight.connectTop.connectedRope = a;
            weight.connectTop.boolConnectedRope = true;
            ropes.add(a);

            return true;
        } else if (holdingRope && !weight.connectTop.occupied) {

            Rope a =  ropes.get(ropes.size()-1);

            if (weight.connectTop.x - 25 < a.connectEnd.x && a.connectEnd.x < weight.connectTop.x + 25) { //rope can only attach to the weight perpendicularly
                a.connectEnd.boolConnectedWeight = true;

                weight.connectTop.occupied = true;
                weight.connectTop.connectedRope = a;
                weight.connectTop.boolConnectedRope = true;
                a.connectEnd.set(weight.connectTop);

                return true;
            } else return false;
        } else return false;
    } else return false;
}
