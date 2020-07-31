using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CustomPhysicsRaycaster : MonoBehaviour
{
    public LineRenderer DrawLine;

    void Update()
    {
        if (OVRInput.Get(OVRInput.NearTouch.SecondaryIndexTrigger))
        {
            DrawLine.enabled = false;
        }
        else
        {
            DrawLine.enabled = true;
        }
		if (OVRInput.GetDown(OVRInput.Button.One)) 
        {
            RaycastHit Hit;
            Ray NewRay = new Ray(transform.position, transform.forward);
			if (Physics.Raycast(NewRay,out Hit)) 
            {
				if (Hit.transform.tag == "Lamp") 
                {
                    Hit.transform.gameObject.GetComponent<MeshRenderer>().enabled = !Hit.transform.gameObject.GetComponent<MeshRenderer>().enabled;
                }
            }
        }
    }
}
