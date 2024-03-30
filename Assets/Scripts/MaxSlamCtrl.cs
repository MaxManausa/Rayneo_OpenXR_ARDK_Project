using RayNeo.API;
using UnityEngine;

public class MaxSlamCtrl : MonoBehaviour
{
    public GameObject m_Cube;
    public GameObject m_Sphere;
    public GameObject m_PlanetEarth;
    public int m_LineCount = 10;
    public float m_CubeSpace = 0.3f;
    // Start is called before the first frame update
    void Start()
    {
        Algorithm.EnableSlamHeadTracker();
        //CreateCubes();
       // OnEnable6Dof();
    }


    private void OnDestroy()
    {
        Algorithm.DisableSlamHeadTracker();
    }
    private void CreateCubes()
    {

        int centerPoint = m_LineCount / 2;

        for (int i = 0; i < m_LineCount; i++)
        {
            for (int j = 0; j < m_LineCount; j++)
            {
                var c = Instantiate(m_Cube);
                c.transform.position = new Vector3(m_CubeSpace * (i - centerPoint), m_Cube.transform.position.y, (m_CubeSpace * (j - centerPoint)));

            }
        }
    }

    private void OnEnable6Dof()
    {
        m_Sphere.SetActive(true);
        m_PlanetEarth.SetActive(true);
    }

    // Update is called once per frame
    void Update()
    {

    }
}
