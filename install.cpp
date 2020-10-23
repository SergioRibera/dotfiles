#include <cstdlib>
#include <bits/stdc++.h>
#include <iostream>
#include <string>
#include <unordered_map>
#include <sstream>
#include <vector>

#define RESET   "\033[0m"
#define BLACK   "\033[30m"      /* Black */
#define RED     "\033[31m"      /* Red */
#define GREEN   "\033[32m"      /* Green */
#define YELLOW  "\033[33m"      /* Yellow */
#define BLUE    "\033[34m"      /* Blue */
#define MAGENTA "\033[35m"      /* Magenta */
#define CYAN    "\033[36m"      /* Cyan */
#define WHITE   "\033[37m"      /* White */
#define BOLDBLACK   "\033[1m\033[30m"      /* Bold Black */
#define BOLDRED     "\033[1m\033[31m"      /* Bold Red */
#define BOLDGREEN   "\033[1m\033[32m"      /* Bold Green */
#define BOLDYELLOW  "\033[1m\033[33m"      /* Bold Yellow */
#define BOLDBLUE    "\033[1m\033[34m"      /* Bold Blue */
#define BOLDMAGENTA "\033[1m\033[35m"      /* Bold Magenta */
#define BOLDCYAN    "\033[1m\033[36m"      /* Bold Cyan */
#define BOLDWHITE   "\033[1m\033[37m"      /* Bold White */

using namespace std;

unordered_map<int, unordered_map<int, string>> languajeMessages = {
    {
        0, { // Spanish Elements
            { 0, "Elige las aplicaciones para instalar las configuraciones (O en su defecto la aplicacion también)" },
            { 1, string(BLUE) + "Las opciones con " + string(YELLOW) + "*" + string(BLUE) + " son obligatorias" + string(RESET) },
            { 2, "Se instalaran de todas maneras" },
            { 3, "Todas" },
            { 4, "Seleccione una opción, para seleccionar más de una separe por , "+string(BLUE)+"(ejemplo: 0,1,2): "+string(RESET) },
            { 5, "Instalando " },
            { 6, "Configurando "+string(YELLOW)+" zsh"+string(BLUE)+" ..." },
            { 7, "¿Desea copiar tambien algunas aplicaciones? estas son:" },
            { 8, "(Sin publicidad)" },
            { 9, "¿Desea Continuar? "+string(YELLOW)+"(s/n):"+string(RESET) },
            { 10, "Instalación Finalizada" },
            { 11, "Sigueme en las redes sociales: " },
            { 12, "Invitame un café: " },
            { 13, "¿Deseas descargar mi repositorio de Walpapers? "+string(YELLOW)+"(s/n):"+string(RESET) }
        }
    },{
        1, {
            {0, "Choose the applications to install the configurations (Or failing that, the application as well)"},
            {1, string (BLUE) + "Options with" + string (YELLOW) + " * " + string (BLUE) + "are mandatory" + string (RESET)},
            {2, "They will install anyway"},
            {3, "All"},
            {4, "Select an option, to select more than one separate by," + string (BLUE) + "(example: 0,1,2): " + string (RESET)},
            {5, "Installing "},
            {6, "Configuring " + string (YELLOW) + " zsh" + string (BLUE) + "..."},
            {7, "Do you want to copy some applications too? These are:"},
            {8, "(No advertising)"},
            {9, "Do you want to continue? " + string (YELLOW) + "(y / n): " + string (RESET)},
            {10, "Installation Completed"},
            {11, "Follow me on social media: "},
            {12, "Invite me a coffee: "},
            {13, "Do you want to download my Walpapers repository? " + string (YELLOW) + "(y / n): " + string (RESET)}
        }
    }
};
int lanSel = 0;

void getLanguaje(){
    cout << endl << endl << "[" << GREEN << "0" << RESET << "] Español" << endl;
    cout << "[" << GREEN << "1" << RESET << "] English" << endl;
    cout << endl << "Para iniciar selecciona tu lenguaje de preferencia: ";
    cin >> lanSel;
    
    if(lanSel == 0 || lanSel == 1)
        return;
    else {
        cout << endl << RED << "Opción incorrecta" << RESET << endl;
        getLanguaje();
    }
}
string appsToInstall;
string defaultAdmPkg = "sudo pacman -S";
string appsCmd[] = {
    " todo",
    " vim",
    " brave-bin",
    " uniyhub",
    " ferdi",
    " telegram-desktop",
    " wps-office",
    " discord"
};

vector<string> split(const string& str, const string& delim)
{
    vector<string> tokens;
    size_t prev = 0, pos = 0;
    bool hasZero = false;
    do
    {
        pos = str.find(delim, prev);
        if (pos == string::npos) pos = str.length();
        string token = str.substr(prev, pos-prev);
        if (!token.empty()){
            if(token.find("0") != string::npos){
                hasZero = true;
            }
            tokens.push_back(token);
        }
        prev = pos + delim.length();
    }
    while (pos < str.length() && prev < str.length());
    if(!hasZero)
        return tokens;
    else
        return vector<string> { "hasZero" };
}

void selectApps(){
    system("clear");
    cout << endl << languajeMessages[lanSel][0] << endl;
    cout << languajeMessages[lanSel][1] << endl << endl;
    cout << YELLOW << "git, yay " << RESET << languajeMessages[lanSel][2] << endl << endl;
    string apps[] = {
        languajeMessages[lanSel][3],
        "Vim", "Brave", "Unity 3D", "Ferdi", "Telegram", "WPS Office", "Discord", "Xampp", "Kavantum", "Wine", "Lutris"
    };
    for (int i = 0; i < apps->length() - 1; i++) {
        cout << "[" << GREEN << i << RESET << "] " << GREEN << apps[i] << RESET << endl;
    }

    cout << endl << languajeMessages[lanSel][4];
    cin >> appsToInstall;

    string cmdInsGit = defaultAdmPkg + " git --noconfirm";
    system(cmdInsGit.c_str());
    system("mkdir repos && cd repos && git clone https://aur.archlinux.org/yay-git.git && cd yay-git && pwd && makepkg -si && cd ../..");

    string cmd = "";
    if(appsToInstall.find(",") != string::npos){
        vector<string> appsIndex = split(appsToInstall, ",");
        if(appsIndex[0] == "hasZero"){
            for (int i = 1; i < appsCmd->length() - 1; i++){
                cmd = cmd + appsCmd[i];
            }
        }else{
            for (int i = 0; i < appsIndex.size(); i++) {
                int ind = stoi(appsIndex[i]);
                cmd = cmd + appsCmd[ind];
            }
        }
    }else{
        if(appsToInstall != "0"){
            int ind = stoi(appsToInstall);
            cmd = appsCmd[ind];
        }else{
            for (int i = 1; i < appsCmd->length() - 1; i++){
                cmd = cmd + appsCmd[i];
            }
        }
    }
    cout << BLUE << languajeMessages[lanSel][5] << YELLOW << cmd << RESET << endl;
    cmd = "yay -S" + cmd;
    cout << cmd;
    system(cmd.c_str());
}
void configure(){
    system("clear");
    // Instalar zsh
    cout << endl << BOLDBLUE << languajeMessages[lanSel][6] << RESET << endl;
    system((defaultAdmPkg + " zsh && chsh -s /bin/zsh").c_str());
    system("sh -c \"$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\"");
    system("git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions");
    system("git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k");
    system("mkdir $HOME/back && cp --backup=$HOME/back/bashrc -f .bashrc $HOME && cp --backup=$HOME/back/p10k.zsh -f .p10k.zsh $HOME && cp --backup=$HOME/back/vim -f .vim $HOME && cp --backup=$HOME/back/zshrc -f .zshrc $HOME && cp --backup=$HOME/back/zshrc.pre-oh-my-zsh -f .zshrc.pre-oh-my-zsh $HOME");
    system("cp --backup=$HOME/back/fzf -fr ./.fzf $HOME && cp --backup=$HOME/back/oh-my-zsh -fr ./.oh-my-zsh $HOME && cp --backup=$HOME/back/vim -fr ./.vim $HOME");
    
    string opt = "";
    cout << endl << BOLDBLUE << languajeMessages[lanSel][13] << RESET << endl;
    cin >> opt;
    if(lanSel == 0){
        if(opt == "s" || opt == "S"){
            system("git clone https://github.com/SergioRibera/my-wallpapers.git $HOME/Wallpapers");
        }
        cout << YELLOW << "El repositorio de imágees se ha clonado correctamente" << RESET << endl; 
    }else{
        if(opt == "y" || opt == "Y"){
            system("git clone https://github.com/SergioRibera/my-wallpapers.git $HOME/Wallpapers");
        }
        cout << YELLOW << "Image repository has been successfully cloned" << RESET << endl;
    }
    system("pause 2");

    cout << BOLDBLUE << languajeMessages[lanSel][10] << endl << endl;
}
void fin(){
    cout << BOLDBLUE << languajeMessages[lanSel][11] << RESET << endl << endl;
    cout << RED << "Youtube  :     https://www.youtube.com/channel/UCm_CD6QqAEgtaHde9UycbuA" << RESET << endl;
    cout << BLUE << "Facebook :     https://facebook.com/SergioRiberaID" << RESET << endl;
    cout << CYAN << "Twitter  :     https://twitter.com/SergioRibera_ID" << RESET << endl;
    cout << MAGENTA << "Twitch   :     https://twitch.tv/sergioriberaid" << RESET << endl;
    cout << YELLOW << "GitHub   :     https://github.com/SergioRibera" << RESET << endl << endl;

    cout << BOLDBLUE << languajeMessages[lanSel][12] << RESET << endl << endl;
    cout << RED << "Ko-fi:  https://ko-fi.com/sergioribera" << RESET << endl;
    cout << YELLOW << "Patreon:  https://www.patreon.com/SergioRibera" << RESET << endl;
    cout << BLUE << "Paypal Me: https://paypal.me/SergioRibera" << RESET << endl;
}
int main(){
    system("clear");
    cout << endl << BOLDBLUE << "Bienvenido al instalador de configuraciones" << RESET << "    (" << RESET;
    cout << "by " << GREEN << "SergioRibera" << RESET << ")" << endl;
    getLanguaje();
    selectApps();
    configure();
    fin();
}
