using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI; // Include the UI namespace

public class CycleChildren : MonoBehaviour
{
    private int currentIndex = 0;
    [SerializeField] private Text artworkText; // Serialize this field to assign from the editor

    void Start()
    {
        // Deactivate all children at start
        foreach (Transform child in transform)
        {
            child.gameObject.SetActive(false);
        }

        // Activate the first child and update the serialized text field
        if (transform.childCount > 0)
        {
            transform.GetChild(0).gameObject.SetActive(true);
            UpdateArtworkText(1); // Start with the first child
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

            // Activate the next child and update the serialized text field
            transform.GetChild(currentIndex).gameObject.SetActive(true);
            UpdateArtworkText(currentIndex + 1);
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

            // Activate the previous child and update the serialized text field
            transform.GetChild(currentIndex).gameObject.SetActive(true);
            UpdateArtworkText(currentIndex + 1);
        }
    }

    // Method to update the serialized Text field
    private void UpdateArtworkText(int artworkNumber)
    {
        if (artworkText != null)
        {
            artworkText.text = "Artwork Piece: " + artworkNumber;
        }
        else
        {
            Debug.LogWarning("Artwork Text component not assigned in the inspector.");
        }
    }
}
