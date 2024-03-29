using JetBrains.Annotations;
using RayNeo;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class Scene3Ctrl : MonoBehaviour
{
    public GameObject menuText;
    public LatticeButton m_mainMenuButton;
    public LatticeButton m_defaultSelectBtn;
    public LatticeButton m_AboutButton;
    public LatticeButton m_hideMenuButton;

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
        LatticeBrain.FocusLevel(m_defaultSelectBtn.level);
        LatticeBrain.SelectButton(m_defaultSelectBtn);
        LatticeBrain.Brain.OnDoubleTap += OnDoubleTapCallBack;
        m_defaultSelectBtn.onClick.AddListener(OnClick);
        m_level2DefaultSelectBtn.onClick.AddListener(CloseLevel2);
        m_deleteLevel1Btn.onClick.AddListener(DeleteLevel1);
        m_deleteLevel2Btn.onClick.AddListener(DeleteLevel2);
        m_mainMenuButton.onClick.AddListener(ToMaxLattice);
        m_AboutButton.onClick.AddListener(AboutLevel);
        m_hideMenuButton.onClick.AddListener(HideMenu);
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
            m_mainMenuButton.gameObject.SetActive(false);
            m_AboutButton.gameObject.SetActive(false);
            m_defaultSelectBtn.gameObject.SetActive(false);
            menuText.SetActive(false);
            hideMenuEnabled = true;
            m_hideMenuButton.GetComponentInChildren<Text>().text = "Show Menu";
        }
        else
        {
            m_mainMenuButton.gameObject.SetActive(true);
            m_AboutButton.gameObject.SetActive(true);
            m_defaultSelectBtn.gameObject.SetActive(true);
            menuText.SetActive(true);
            hideMenuEnabled = false;
            m_hideMenuButton.GetComponentInChildren<Text>().text = "Hide Menu";
        }

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
        LatticeBrain.FocusLevel(m_defaultSelectBtn.level);
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
