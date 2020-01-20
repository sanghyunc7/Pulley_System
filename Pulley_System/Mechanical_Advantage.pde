void findMA(Rope a, Pulley pulley, String connectorType, boolean samePulleyAsPrevious) {
    
    
    //how this thing works
    //for a pulley system to be valid, a rope connection must exist from the handle to the weight
    //the entire length of the rope, however, is composed of smaller portions, which are connected to various pulleys
    //depending on how the rope/pulley/weight strucure is arranged, it determines whether the pulley system is valid, and if so, what mechanical advantage value it would have
    
    //starting at the handle's rope, this recursive function explores what connections exist at the end of the latest build
    //the end of each build gets passed recursively, until there is no more rope or a build condition is broken
    //if the overall build happens to be valid, the user can pull down the handle to lift the weight up
    
   
    boolean cut = false; //sometimes, else statements aren't ideal in nested if statements


    if (a.connectStart.boolConnectedWeight || a.connectEnd.boolConnectedWeight) { //the ma = 1 because only a single rope is being used to lift the weight up
        if (a.connectStart.x == a.connectEnd.x) { //let the system only run if the rope attached to the weight is perpendicular
            systemValid = true;
        }

    } else if ((a.connectStart.boolConnectedHook || a.connectEnd.boolConnectedHook) && weightAttachedToPulley) { //the pulley system is also complete if the end of the entire rope ends at a hook, and along the way it is connected through a pulley that is attached to a weight
//the ma = 2 because two ropes are being used to lift the weight up

        Pulley pulleyTemp = weight.connectTop.connectedPulley;

        if (pulleyTemp.connectLeft.connectedRope.connectStart.x == pulleyTemp.connectLeft.connectedRope.connectEnd.x) { //this prevents the case when the user tries to modify a valid system into something invalid by making non-perpendicular connections with the weight's pulley
            systemValid = true;
        }
    } else if (a.connectStart.boolConnectedPulley) { //if for some weird reason, the user wants to attach the end of the entire rope to one of the pulley's top/bottom connectors, ma = 2

        Pulley pulleyTemp = a.connectStart.connectedPulley;

        if (pulleyTemp.connectTop.boolConnectedRope) { 
            if (pulleyTemp.connectTop.connectedRope.equals(a)) {
                systemValid = true;
                cut = true;
            }
        }
        if (pulleyTemp.connectBottom.boolConnectedRope) {
            if (pulleyTemp.connectBottom.connectedRope.equals(a)) {
                systemValid = true;
                cut = true;
            }
        }
    }
    if (a.connectEnd.boolConnectedPulley && !cut) {

        Pulley pulleyTemp = a.connectEnd.connectedPulley;

        if (pulleyTemp.connectTop.boolConnectedRope) {
            if (pulleyTemp.connectTop.connectedRope.equals(a)) {
                systemValid = true;
                cut = true;
            }
        }
        if (pulleyTemp.connectBottom.boolConnectedRope) {
            if (pulleyTemp.connectBottom.connectedRope.equals(a)) {
                systemValid = true;
                cut = true;
            }
        }
    }


//if none of our base cases have been reached by this point, proceed on our 'else' cases
//because of the complex nature of this recursion, an 'else' condition was not actually used

    if (!cut) { 

        if (!samePulleyAsPrevious) { //if this is a new pulley we are on

            if (pulley.connectBottom.boolConnectedWeight) { //if our path came across a pulley that has a weight attached to the bottom

                if (pulley.connectTop.boolConnectedRope) {
                    ma = 1;
                } else {
                    ma = 2;
                }
                weightAttachedToPulley = true;
            }


            if (pulley.connectTop.boolConnectedHook || pulley.connectBottom.boolConnectedHook || pulley.connectBottom.boolConnectedWeight) { //make sure that the pulley we are travelling to is fixed onto a hook

                if (connectorType.equals("right") && (pulley.connectLeft.boolConnectedRope)) { //this is the connectorType we are on
                    //if our next destination has a rope attached to it

                    connectorType = "left"; //our next destination will still be on the same pulley, but the connector is on the other side
                    a = pulley.connectLeft.connectedRope; //update rope
                    findMA(a, pulley, "left", true);  //recursive call
                    //
                } else if (connectorType.equals("left") && (pulley.connectRight.boolConnectedRope)) {

                    connectorType = "right";
                    a = pulley.connectRight.connectedRope;
                    findMA(a, pulley, "right", true);
                }
            }
        } else { //if samePulleyAsPrevious = true - if we are still on the same pulley, just on the other side

            if (a.connectStart.boolConnectedPulley) { //we need to determine which end of our rope has the pulley that we are currently on
                if (a.connectStart.connectedPulley.equals(pulley)) {  //now that we know a.connectEnd is where we want to visit
                    if (a.connectEnd.boolConnectedPulley) { //if it is attached to another pulley

                        pulley = a.connectEnd.connectedPulley; 
                        connectorType = determineConnectorType(a, pulley);
                        findMA(a, pulley, connectorType, false);
                        cut = true;
                    }
                }
            }  
            if (a.connectEnd.boolConnectedPulley && !cut) {   //now check the other end of the rope...
                if (a.connectEnd.connectedPulley.equals(pulley)) {
                    if (a.connectStart.boolConnectedPulley) { 

                        pulley = a.connectStart.connectedPulley; 
                        connectorType = determineConnectorType(a, pulley);
                        findMA(a, pulley, connectorType, false);
                    }
                }
            }
        }
    }
}

String determineConnectorType(Rope a, Pulley pulley) { //determine which connector of the pulley the rope is attached to

    if (pulley.connectLeft.boolConnectedRope) {
        if (pulley.connectLeft.connectedRope.equals(a)) {

            return "left";
        }
    }

    if (pulley.connectRight.boolConnectedRope) {
        if (pulley.connectRight.connectedRope.equals(a)) {

            return "right";
        }
    }
    return "neither"; //the program will not know what to do with this statement, so this is one way the recursion will stop, and therefore by default, the system will be considered invalid
}
