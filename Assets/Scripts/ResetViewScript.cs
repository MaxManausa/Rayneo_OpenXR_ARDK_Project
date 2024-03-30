using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class ResetViewScript : MonoBehaviour
{
    [SerializeField] private GameObject parentObject; // The new parent object for childObject
    [SerializeField] private GameObject childObject; // The object whose view is to be reset

    public void ResetView()
    {
        StartCoroutine(ResetViewCoroutine());
    }

    private IEnumerator ResetViewCoroutine()
    {
        // Set childObject as a child of parentObject
        childObject.transform.SetParent(parentObject.transform);

        // Reset only childObject's local position and rotation to (0, 0, 0)
        childObject.transform.localPosition = Vector3.zero;
        childObject.transform.localRotation = Quaternion.Euler(0, 0, 0);

        // Wait for one second
        yield return new WaitForSeconds(1);

        // Unparent childObject while maintaining its world position and rotation
        // Note: This action doesn't directly affect the local positions and rotations of its children relative to it
        childObject.transform.SetParent(null, false);
    }
}
