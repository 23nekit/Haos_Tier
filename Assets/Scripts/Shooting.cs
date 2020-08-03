using OculusSampleFramework;
using OVRTouchSample;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shooting: MonoBehaviour
{
	public GameObject BulletPrefab;
	public OVRGrabbable Pistol;
	public OVRGrabber Hand;
	public OVRGrabber Hand2;
	public Transform BarrelLocation;
	public Transform BarrelLocation2;

	public void Update()
	{
		if (OVRInput.GetDown(OVRInput.Button.SecondaryIndexTrigger) &&( Hand.grabbedObject == Pistol||Hand2.grabbedObject==Pistol))     
		{
			Rigidbody NewBulletRigidbody = Instantiate(BulletPrefab, BarrelLocation.position, Quaternion.identity).GetComponent<Rigidbody>();
			NewBulletRigidbody.AddForce((BarrelLocation2.position - BarrelLocation.position)*50, ForceMode.Impulse);
			Destroy(NewBulletRigidbody.gameObject, 3);
		}
	}
}
