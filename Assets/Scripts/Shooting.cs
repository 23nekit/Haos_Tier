using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shooting: MonoBehaviour
{
	public GameObject BulletPrefab;
	public GameObject Pistol;
	public GameObject RightHand;
	public Transform BarrelLocation;
	public Transform BarrelLocation2;

	public static bool PistolDetected;
	public void Update()
	{
		if (OVRInput.GetDown(OVRInput.Button.SecondaryIndexTrigger)&& PistolDetected) 
		{
			Rigidbody NewBulletRigidbody = Instantiate(BulletPrefab, BarrelLocation.position, Quaternion.identity).GetComponent<Rigidbody>();
			NewBulletRigidbody.AddForce((BarrelLocation2.position - BarrelLocation.position)*50, ForceMode.Impulse);
			Destroy(NewBulletRigidbody.gameObject, 3);
		}
	}
}
