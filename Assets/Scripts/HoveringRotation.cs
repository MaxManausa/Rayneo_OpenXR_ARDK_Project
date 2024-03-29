using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoveringRotation : MonoBehaviour
{
    [SerializeField] private float amplitude = 1.0f; // Amplitude of sinusoidal motion
    [SerializeField] private float speed = 1.0f; // Speed of the sinusoidal motion
    [SerializeField] private float rotationSpeed = 30.0f; // Speed of the rotation around the Y-Axis

    private Vector3 startPosition = Vector3.zero;

    // Start is called before the first frame update
    void Start()
    {
        startPosition = transform.position;
    }

    // Update is called once per frame
    void Update()
    {
        // Sinusoidal motion
        float newY = Mathf.Sin(Time.time * speed) * amplitude;
        transform.position = new Vector3(startPosition.x, startPosition.y + newY, startPosition.z);

        // Rotation around the Y-axis
        transform.Rotate(0, rotationSpeed * Time.deltaTime, 0);


    }
}