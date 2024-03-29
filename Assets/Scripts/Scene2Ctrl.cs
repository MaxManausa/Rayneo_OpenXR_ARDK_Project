using RayNeo;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Scene2Ctrl : MonoBehaviour
{
    public LatticeButton m_6DofBtn;
    public LatticeButton m_defaultSelectBtn;
    public LatticeButton m_AboutButton;
    public LatticeButton m_CloseButton;

    public LatticeButton m_level2DefaultSelectBtn;
    public GameObject m_level2Obj;

    public LatticeButton m_deleteLevel1Btn;
    public LatticeButton m_deleteLevel2Btn;



    public void OnDoubleTapCallBack()
    {
        CloseLevel2();
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
        m_6DofBtn.onClick.AddListener(To6DOFScene);
        m_AboutButton.onClick.AddListener(AboutLevel);
        m_CloseButton.onClick.AddListener(CloseApp);
    }

    private void To6DOFScene()
    {
        SceneManager.LoadScene("MaxSlam");

    }

    private void AboutLevel()
    {
        //ah yeah son
    }

    public void CloseApp()
    {
        Application.Quit();
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