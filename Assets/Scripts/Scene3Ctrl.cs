using JetBrains.Annotations;
using RayNeo;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class Scene3Ctrl : MonoBehaviour
{
    public GameObject menuText;
    public GameObject objectCounterText;

    public LatticeButton button1;
    public LatticeButton button2;
    public LatticeButton button3;
    public LatticeButton button4;
    public LatticeButton button5;

    [SerializeField] private CycleChildren cycleChildren;
    [SerializeField] private ResetViewScript resetViewScript;

    public LatticeButton m_level2DefaultSelectBtn;
    public GameObject m_level2Obj;

    public LatticeButton m_deleteLevel1Btn;
    public LatticeButton m_deleteLevel2Btn;

    private bool hideMenuEnabled = false;



    public void OnDoubleTapCallBack()
    {
       // CloseLevel2();
    }

    void Start()
    {
        LatticeBrain.FocusLevel(button2.level);
        //LatticeBrain.SelectButton(button2);
        LatticeBrain.Brain.OnDoubleTap += OnDoubleTapCallBack;
        button2.onClick.AddListener(Next);
        //m_level2DefaultSelectBtn.onClick.AddListener(CloseLevel2);
        //m_deleteLevel1Btn.onClick.AddListener(DeleteLevel1);
        //m_deleteLevel2Btn.onClick.AddListener(DeleteLevel2);
        button4.onClick.AddListener(ToMaxLattice);
        button3.onClick.AddListener(Previous);
        button5.onClick.AddListener(HideMenu);
        //button1.onClick.AddListener(ResetTheView);
        hideMenuEnabled = false;
    }

    private void ToMaxLattice()
    {
        SceneManager.LoadScene("MaxLattice");

    }

    private void AboutLevel()
    {
        //ah yeah son
    }

    public void HideMenu()
    {
        if (!hideMenuEnabled)
        {
            // Assuming LatticeButton has a gameObject property or is a MonoBehaviour
            button4.gameObject.SetActive(false);
            button3.gameObject.SetActive(false);
            button2.gameObject.SetActive(false);
            //button1.gameObject.SetActive(false);
            menuText.SetActive(false);
            objectCounterText.SetActive(false);
            hideMenuEnabled = true;
            button5.GetComponentInChildren<Text>().text = "Show Menu";
        }
        else
        {
            button4.gameObject.SetActive(true);
            button3.gameObject.SetActive(true);
            button2.gameObject.SetActive(true);
            //button1.gameObject.SetActive(true);
            menuText.SetActive(true);
            objectCounterText.SetActive(true);
            hideMenuEnabled = false;
            button5.GetComponentInChildren<Text>().text = "Hide Menu";
        }

    }

    public void ResetTheView()
    {
        resetViewScript.ResetView();
    }

    public void Next()
    {
        cycleChildren.ActivateNextChild();
    }

    public void Previous()
    {
        cycleChildren.ActivatePreviousChild();
    }
    
    private void DeleteLevel1()
    {
        LatticeBrain.RemoveButton(m_deleteLevel1Btn);
    }

    private void DeleteLevel2()
    {
        LatticeBrain.RemoveButton(m_deleteLevel2Btn);

    }

    private void CloseLevel2()
    {
        m_level2Obj.SetActive(false);
        LatticeBrain.MovingChangeItem = false;
        LatticeBrain.FocusLevel(button2.level);
    }

    

    private void OnClick()
    {
        m_level2Obj.SetActive(true);
        LatticeBrain.MovingChangeItem = true;
        LatticeBrain.SelectButton(m_level2DefaultSelectBtn, true);
    }
    // Update is called once per frame
    void Update()
    {

    }
}
