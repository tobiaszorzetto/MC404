#include <fcntl.h> //open
#include <unistd.h> //read, write, close
#include <stdio.h>

typedef struct
{
    int e_shoff;
    int e_shnum;
    int e_shstrndx;
} Header;

typedef struct 
{   
    int endereco;
    int tamanho;
    unsigned char nome[20];
    char *conteudo;

} Section;

void decimalToHexa(unsigned char numero_decimais[], unsigned char numero_hexa[], int tamanho ){
    printf("%s\n", numero_decimais);
    for (int i = tamanho - 1; i>=0 ; i-=2)
    {
        int cont = 0;
        numero_hexa[i*2] = 0;
        numero_hexa[i*2-1] = 0;
        for(int numero = numero_decimais[i]; numero>0; numero/=16 ){
            numero_hexa[i*2-cont] = numero%16;
            if(numero%16> 9 ){
                numero_hexa[i*2-cont]+=87;
            }
            cont++;
            
        }
    }
    printf("%s\n", numero_hexa);
}

int calcularHexa(unsigned char numero_hexa[], int tamanho){
    int numero = 0;
    int base = 1;
    for(int i = tamanho-1; i>=0;i--){
        if(numero_hexa[i]>10){
            numero_hexa[i]-=87;
        }
        numero += numero_hexa[i]*base;
        base*=16;
    }
    return numero;
}

int calcular(unsigned char buf[], int inicio, int tamanho){
    unsigned char numero_hexa[tamanho*2];
    unsigned char numero_decimal[tamanho];
    int j = 0;
    for (int i = inicio+tamanho - 1; i>=inicio ; i--)
    {
        numero_decimal[j] = buf[i];
        j++;
    }
    printf("a\n");
    for(int i = 0; i<tamanho;i++){
        printf("%d",numero_decimal[tamanho]);
    } printf("\n");
    
    decimalToHexa(numero_decimal,numero_hexa,tamanho);
    printf("%s \n",numero_hexa);
    return calcularHexa(numero_hexa, tamanho);
}

Header abrirArquivo(unsigned char buf[]){
    int fd = open("/home/tobias/mc404/test.x", O_RDONLY);
    size_t nbytes = 100000;
    read(fd,buf,nbytes);

    Header header;
    header.e_shoff = calcular(buf,32,4);
    header.e_shnum = calcular(buf,48,2);
    header.e_shstrndx = calcular(buf,50,2);
    
    return header;

}

void pegarNome(int inicio, unsigned char *nome, unsigned char buf[]){
    for(int i = 0; buf[inicio + i] != 0; i++){
        nome[i] = buf[inicio+i];
    }
}


void analisarSecoes(Section *sections, unsigned char buf[], Header header ){
    int inicio = header.e_shoff;

    int offset = buf[inicio+header.e_shstrndx*40 + 16];

    for(int i = 0; i<header.e_shnum; i++){
        pegarNome(offset + buf[inicio + i * 40],sections[i].nome, buf);
        sections[i].endereco = buf[inicio + i * 40 + 16 ];
        sections[i].tamanho = buf[inicio + i * 40 + 20 ];
    }
}

void imprimirHeader(char** arquivo){

}

void imprimirTexto(char** arquivo){

}

int main(){

    unsigned char buf[1000000];
    Header header = abrirArquivo(buf);
    Section sections[header.e_shnum];
    analisarSecoes(sections, buf,header);

    /*
    if(argv[1] == "-t"){
        imprimirTexto(arquivo);
    }
    else if(argv[1] == "-h"){
        imprimirHeader(arquivo);
    } 
    else if(argv[1] == "-d"){

    }*/
    return 0;
}