using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Target : MonoBehaviour
{
	public Vector2 CenterOfCircleSpawn;
	public float Radius;
	public float Speed;
	public float Angle;
	private void Update()
	{
		Angle += Speed * Time.deltaTime;
		float x = Mathf.Cos(Angle) * Radius;
		float y = Mathf.Sin(Angle) * Radius;
		transform.position = new Vector3(-(new Vector2(x, y) + CenterOfCircleSpawn).x, (new Vector2(x, y) + CenterOfCircleSpawn).y, transform.position.z);
	}

	private void OnCollisionEnter(Collision collision)
	{
		if (collision.transform.tag == "Bullet") 
		{
			Destroy(gameObject);
			Destroy(collision.gameObject);
		}
	}
}
