using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MakeInactive : MonoBehaviour
{
    public float delayInSeconds = 5f;

    void OnEnable()
    {
        StartCoroutine(DeactivateAfterDelay());
    }

    IEnumerator DeactivateAfterDelay()
    {
        yield return new WaitForSeconds(delayInSeconds);
        gameObject.SetActive(false);
    }
}
