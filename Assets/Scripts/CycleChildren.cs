using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CycleChildren : MonoBehaviour
{
    private int currentIndex = 0;

    void Start()
    {
        // Deactivate all children at start
        foreach (Transform child in transform)
        {
            child.gameObject.SetActive(false);
        }

        // Activate the first child
        if (transform.childCount > 0)
        {
            transform.GetChild(0).gameObject.SetActive(true);
        }
    }

    public void ActivateNextChild()
    {
        // Deactivate the current child
        if (transform.childCount > 0)
        {
            transform.GetChild(currentIndex).gameObject.SetActive(false);

            // Increment the index, wrap around if it exceeds the number of children
            currentIndex = (currentIndex + 1) % transform.childCount;

            // Activate the next child
            transform.GetChild(currentIndex).gameObject.SetActive(true);
        }
    }

    public void ActivatePreviousChild()
    {
        // Deactivate the current child
        if (transform.childCount > 0)
        {
            transform.GetChild(currentIndex).gameObject.SetActive(false);

            // Decrement the index, wrap around if it goes below 0
            currentIndex = (currentIndex - 1 + transform.childCount) % transform.childCount;

            // Activate the previous child
            transform.GetChild(currentIndex).gameObject.SetActive(true);
        }
    }
}