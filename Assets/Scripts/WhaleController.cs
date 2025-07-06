using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WhaleController : MonoBehaviour
{
    public Transform centralPoint; // Assign the central point's transform in the Unity Editor
    public Vector3 rotationAxis = Vector3.up; // Default rotation axis is the Y-axis
    public float rotationSpeed = 20.0f; // Rotation speed in degrees per second

    void Update()
    {
        if (centralPoint != null)
        {
            // Rotate around the central point at the specified speed
            transform.RotateAround(centralPoint.position, rotationAxis, rotationSpeed * Time.deltaTime);
        }
    }
}

