using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FPS : MonoBehaviour
{
    public OVRDebugInfo PlayerDebugInfo;
    public Text TextObj;

    void Update()
    {
        float current = (int)(1f / Time.deltaTime);
		if (Time.frameCount % 50 == 0)
        {
            TextObj.text = "FPS :" + current;
        }
    }
}
