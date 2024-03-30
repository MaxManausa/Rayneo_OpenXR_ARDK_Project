using UnityEngine;

public class ScaleParticleSystem : MonoBehaviour
{
    public float scaleFactor = 0.1f; // Example scale factor

    void Start()
    {
        ParticleSystem ps = GetComponent<ParticleSystem>();

        if (ps != null)
        {
            var main = ps.main;
            main.startSizeMultiplier *= scaleFactor;
            main.startLifetimeMultiplier *= scaleFactor;
            var emission = ps.emission;
            emission.rateOverTimeMultiplier *= scaleFactor;
            // Add more properties as needed
        }

        // Repeat for any sub-emitters
    }
}