using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class CharacterManager : MonoBehaviour {

	private static CharacterManager instance;
	public static CharacterManager GetInstance() {
		GameObject main = GameObject.Find("Main");
		if (main == null) {
			main = new GameObject("Main");
			DontDestroyOnLoad(main);
		}
	
		if (instance == null) {
			instance = main.AddComponent<CharacterManager>();
		}
		return instance;
	}


	private List<Character> m_Characters = new List<Character>();

	public Player AddPlayer(Vector3 pos, Quaternion rot) {
		Object prefab = ResourceManager.GetInstance().LoadAsset("Prefabs/Character/king");
		GameObject go = GameObject.Instantiate(prefab, pos, rot) as GameObject;
		//go.transform.localScale = Vector3.one;
		Player player = go.GetComponent<Player>();
		m_Characters.Add(player);
		return player;
	}

	public Player AddPlayer(float x, float y, float z) {
		return AddPlayer (new Vector3 (x, y, z), Quaternion.identity);
	}  

	public Enemy AddEnemy(int id, Vector3 pos, Quaternion rot) {
		Object prefab = ResourceManager.GetInstance().LoadAsset("Prefabs/Enemy/"+id);
		GameObject go = GameObject.Instantiate(prefab, pos, rot) as GameObject;
		//go.transform.localScale = Vector3.one;
		Enemy enemy = go.GetComponent<Enemy>();
		m_Characters.Add(enemy);
		return enemy;
	}  

	public Enemy AddEnemy(int id, float x, float y, float z) {
		return AddEnemy (id, new Vector3 (x, y, z), Quaternion.identity);
	}

	public bool CheckEnemyInArea( Vector3 pos, float range) {
		
		foreach(Character ch in m_Characters) {
			if (ch is Enemy) {
				Vector3 offset = ch.transform.position - pos;
				if (offset.magnitude < range) {
					return true;
				}
			}
		}

		return false;
	}

	public Enemy FindNearestEnemy(Vector3 pos, out float distance) {
		Enemy ret = null;
		distance = float.MaxValue;
		foreach(Character ch in m_Characters) {
			if (ch is Enemy && ch.IsAlive()) {
				Vector3 offset = ch.transform.position - pos;
				if (offset.magnitude < distance) {
					distance = offset.magnitude;
					ret = ch as Enemy;
				}
			}
		}

		return ret;
	}

	public bool Remove(Character character) {
		Destroy(character.gameObject);
		return m_Characters.Remove(character);
	}

	public void RemoveAll() {
		foreach(Character ch in m_Characters) {
			if (ch != null) {
				Destroy(ch.gameObject);
			}
		}
		m_Characters.Clear();
	}
}