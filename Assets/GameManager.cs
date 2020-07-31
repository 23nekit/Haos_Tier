using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    public AudioSource BossTheme;
    public VideoPlayer BossView;
    public AudioSource BossSoundEffect;
    public TargetManager TargetManagerObject;

	public void StartGame()
    {
        BossView.Play();
        BossSoundEffect.Play();
        BossTheme.Play();
        TargetManagerObject.SpawnTargetAndAddOneDifficulty();
    }
}
