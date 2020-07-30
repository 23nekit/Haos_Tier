using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetManager : MonoBehaviour
{
    public GameObject TargetPrefab;
    public Vector2 CenterOfCircleSpawn;
    public static List<GameObject> AllTargets;
	public float Radius = 0.5f;
	public float MaxTargets;
	public float Speed;
	private float FullAngle = 3.6f;

	private void Start()
	{
		SpawnTargetAndAddOneDifficulty();
	}
	public void SpawnTargetAndAddOneDifficulty() 
	{
		float AngleForSpawnOne = FullAngle / MaxTargets;
		Debug.Log("AngleForSpawnOne: " + AngleForSpawnOne);
		for (int i = 0; i < MaxTargets; i++)
		{
			Debug.Log("AngleForSpawnOne: " + AngleForSpawnOne * i);
			float x = Mathf.Cos(AngleForSpawnOne * i) * Radius;
			float y = Mathf.Sin(AngleForSpawnOne * i) * Radius;
			Instantiate(TargetPrefab, new Vector3(-(new Vector2(x, y) + CenterOfCircleSpawn).x, (new Vector2(x, y) + CenterOfCircleSpawn).y, TargetPrefab.transform.position.z), TargetPrefab.transform.rotation);
		}
	}
}
