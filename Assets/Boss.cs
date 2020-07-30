using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Boss : MonoBehaviour
{
    public AudioSource DamageSoundEffect;

	private void OnCollisionEnter(Collision collision)
	{
		DamageSoundEffect.Play();
		Destroy(collision.gameObject);
	}
}
