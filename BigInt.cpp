#include "BigInt.h"
#include <iostream>
#include <cmath>
#include <climits>
#include <cctype>

BigInt::BigInt():
    neg(false),
    nDig(1),
    d(new int8_t[1]{0})
{}

BigInt::BigInt(bool isNeg, int size)
{
    neg = isNeg;
    if(size >= 0)nDig = size;
    else nDig = 0;

    if(nDig>0) d = new int8_t[nDig]{0};
    else d = nullptr;
}

BigInt::BigInt(long long int N):
  BigInt(N<0, (N!=0 ? 1+int(log10(fabs(N))) : 1) )
  {
    for (int i=0; i<size(); ++i) {
      d[i] = abs(N%10);
      N /= 10;
    }
  }

BigInt::BigInt(const BigInt& other)
    : neg(other.neg), nDig(other.nDig), d(nullptr)
{
     if (nDig > 0) {
        d = new int8_t[nDig];
        for (int i = 0; i < nDig; ++i) {
            d[i] = other.d[i];
        }
    }
}

BigInt::BigInt(BigInt&& other) noexcept
    : neg(other.neg), nDig(other.nDig), d(other.d)
{
    other.d = nullptr;
    other.nDig = 0;
    other.neg = false;
}

BigInt& BigInt::operator=(const BigInt& other) {
    if (this != &other)
    {
        delete[] d;

        neg = other.neg;
        nDig = other.nDig;
        d = nullptr;

        if (nDig > 0)
        {
            d = new int8_t[nDig];
            for (int i = 0; i < nDig; ++i)
            {
                d[i] = other.d[i];
            }
        }
    }
    return *this;
}

BigInt& BigInt::operator=(BigInt&& other) noexcept {
    if(this != &other)
        {
            delete[] d;
            neg = other.neg;
            nDig = other.nDig;
            d = other.d;
            other.d = nullptr;
            other.nDig = 0;
            other.neg = false;
        }
        return *this;
    }

bool BigInt::isNeg() const{
    return neg;
}
int BigInt::size() const{
    return nDig;
}
bool BigInt::isZero() const{
    return (nDig == 1 && d[0] == 0);
}
int BigInt::operator[](int i) const{
    if (i>=nDig || i<0) return 0;
    return d[i];
}

void BigInt::correct(){
    if(nDig <= 0 || d == nullptr)
    {
        *this = BigInt();
        return;
    }

    int nSize = nDig;
    while (nSize > 1 && d[nSize - 1] == 0)
    {
        nSize--;
    }

    if(nSize != nDig)
    {
        BigInt prov(isNeg(), nSize);
    for (int i=0; i<prov.size(); ++i) prov.d[i] = d[i];
    *this = std::move(prov);
    }

    if(nDig == 1)
    {
        if(d[0]<0)
        {
            neg = !neg;
            d[0] = std::abs(d[0]);
        }
        if(d[0]==0)
        {
            neg = false;
        }
    }


}

BigInt::BigInt(const std::string& S):
    BigInt()
{

    if(S.empty())
    {
        std::cerr<< "Erro\n";
        return;
    }

    bool isNeg = false;
    size_t ini = 0;

    if(S[0] == '+' || S[0] == '-')
    {
        if(S.size()==1)
        {
            std::cerr<< "Erro\n";
            return;
        }
        isNeg = (S[0] == '-');
        ini = 1;
    }

    *this = BigInt(isNeg, S.size()-ini);

    for(int i=0; i<nDig; i++)
    {
        char c = S[S.size() - 1 - i];
        if(!isdigit(static_cast<unsigned char>(c)))
        {
            std::cerr<< "Erro\n";
            *this = BigInt();
            return;
        }

        d[i] = static_cast<int8_t>(c - '0');
    }

    neg = isNeg;
    correct();
}

long long BigInt::toInt()const
{
    long long val = 0;

    for(int i = nDig - 1; i>=0; --i)
    {
        val = 10 * val + d[i];
        if(val < 0)
        {
            std::cerr<< "Erro\n";
            return 0;
        }
    }

    if(neg)val = -val;
    {
        return val;
    }

}

std::ostream& operator<<(std::ostream& os, const BigInt& B)
{
    if(B.neg && !B.isZero()) os <<'-';
    for(int i = B.size() - 1; i>=0; --i)
    {
        os << B[i];
    }
    return os;
}

std::istream& operator>>(std::istream& is, BigInt& B)
{
    B = BigInt();

    bool neg = false;
    char c;

    is >> std::ws;

    if (is.peek() == '+' || is.peek() == '-')
    {
        c = is.get();
        if (c == '-') neg = true;
    }

    bool leuDigito = false;

    while (true)
    {
        c = is.peek();

        if (!isdigit(static_cast<unsigned char>(c)))
            break;

        leuDigito = true;

        int dig = is.get() - '0';

        B = B * BigInt(10) + BigInt(dig);
    }

    if (!leuDigito)
    {
        is.setstate(std::ios::failbit);
        B = BigInt();
        return is;
    }

    if (neg)
        B = -B;

    return is;
}

BigInt abs(const BigInt& X) {
    BigInt R(X);
        R.neg = false;
    return R;
}

bool operator==(const BigInt& A, const BigInt& B) {
    if (A.neg != B.neg || A.nDig != B.nDig)
        return false;
    for (int i = 0; i < A.nDig; ++i) {
        if (A[i] != B[i]) return false;
    }
    return true;
}

bool operator!=(const BigInt& A, const BigInt& B) {
    return !(A == B);
}

bool operator<(const BigInt& A, const BigInt& B) {
    if (A.neg != B.neg)
        return A.neg;

    if (A.neg) return abs(B) < abs(A);
    if (A.nDig != B.nDig) return A.nDig < B.nDig;
    for (int i = A.nDig - 1; i >= 0; --i) {
        if (A[i] != B[i]) return A[i] < B[i];
    }
    return false;
}

bool operator>(const BigInt& A, const BigInt& B) {
    return B < A;
}

bool operator<=(const BigInt& A, const BigInt& B) {
    return !(B < A);
}

bool operator>=(const BigInt& A, const BigInt& B) {
    return !(A < B);
}

void BigInt::increment()
{
    int k = 0;
    d[k] = d[k]+1;

    while(k<nDig-1 && d[k]>9)
    {
        d[k] = 0;
        ++(d[++k]);
    }

    if (k==size()-1 && d[k]>9)
    {
        BigInt prov(isNeg(), size()+1);
        for (int i=0; i<size()-1; ++i) prov.d[i] = d[i];
        prov.d[size()-1] = 0;
        prov.d[size()] = 1;
        *this = std::move(prov);
    }
}

void BigInt::decrement()
{
    int k = 0;
    d[k] = d[k] - 1;

    while(k<nDig - 1 && d[k]<0)
    {
        d[k] = 9;
        --(d[++k]);
    }
    if(k==nDig - 1 && d[k]<=0)
    {
        correct();
    }
}

BigInt& BigInt::operator++()
{
    if(!neg)
    {
        increment();
    }
    else
    {
        decrement();
    }
    return *this;
}

BigInt& BigInt::operator--()
{
    if(neg)
    {
        increment();
    }
    else
    {
        decrement();
    }
    return *this;
}

BigInt BigInt::operator++(int)
{
    BigInt copiatemp(*this);
    ++(*this);
    return copiatemp;
}

BigInt BigInt::operator--(int)
{
    BigInt copiatemp(*this);
    --(*this);
    return copiatemp;
}

const BigInt& BigInt::operator+() const
{
    return *this;
}

BigInt BigInt::operator-() const
{
    BigInt result(*this);
    if(!isZero())
    {
        result.neg = !result.neg;
    }
    return result;
}

BigInt operator+(const BigInt& A, const BigInt& B)
{
    if (A.neg == B.neg) {
        int maxSize = std::max(A.nDig, B.nDig) + 1;
        BigInt C( A.isNeg(), maxSize );
        int carry = 0;
        for (int i = 0; i < maxSize; i++) {
            int av = (i < A.nDig ? A.d[i] : 0);
            int bv = (i < B.nDig ? B.d[i] : 0);
            int soma = av + bv + carry;
            C.d[i] = soma % 10;
            carry = soma / 10;
        }
        C.correct();
        return C;
    } else {
        if (abs(A) >= abs(B)) {
            BigInt C( A.isNeg(), A.size() );
            int borrow = 0;
            for (int i = 0; i < A.nDig; i++) {
                int av = A.d[i];
                int bv = (i < B.nDig ? B.d[i] : 0);
                int sub = av - bv - borrow;
                if (sub < 0) {
                    sub += 10;
                    borrow = 1;
                } else {
                    borrow = 0;
                }
                C.d[i] = sub;
            }
            C.correct();
            return C;
        } else {
            return B + A;
        }
    }
}

BigInt operator-(const BigInt& A, const BigInt& B)
{
    return A + (-B);
}

BigInt operator*(const BigInt& A, const BigInt& B)
{
    if(A.isZero() || B.isZero())
    {
        return BigInt(0);
    }

    BigInt C(A.isNeg()!=B.isNeg(), A.size()+B.size());

    for(int i = 0; i < A.size(); i++)
        {
            if (A.d[i] == 0) continue;
            for(int j = 0; j < B.size(); j++)
            {
                if (B.d[j] == 0)
                {
                    continue;
                }

                int k = i + j;
                int produto = A.d[i] * B.d[j];
                C.d[k] += produto;

                while(C.d[k] > 9)
                    {
                        int carry = C.d[k] / 10;
                        C.d[k] %= 10;
                        k++;
                        C.d[k] += carry;
                    }
            }
        }

    C.correct();
    return C;
}

BigInt BigInt::operator!() const
{
    if (isNeg())
        {
            std::cerr << "Erro\n";
            return BigInt(0);
        }

    BigInt C(1);
    BigInt N(2);

    while (N <= *this)
        {
            C = C * N;
            ++N;
        }

    return C;
}

BigInt operator<<(const BigInt& A, int N)
{
    if(N <= 0 || A.isZero())
    {
        return A;
    }

    BigInt C(A.neg, A.size() + N);

    for(int i = 0; i < N; i++)
    {
        C.d[i] = 0;
    }

    for(int i = 0; i < A.size(); i++)
    {
        C.d[i + N] = A.d[i];
    }

    return C;
}

BigInt operator>>(const BigInt& A, int N)
{
    if(N <= 0 || A.isZero())
    {
        return A;
    }

    if(N >= A.size())
    {
        return BigInt(0);
    }

    BigInt C(A.neg, A.size() - N);

    for (int i = 0; i < C.nDig; i++)
    {
        C.d[i] = A.d[i + N];
    }

    return C;
}

void BigInt::division(const BigInt& D, BigInt& Q, BigInt& R)const
{
    if(D.isZero())
    {
        std::cerr << "Erro(Divisao por zero)\n";
        Q = BigInt(0);
        R = BigInt(0);
        return;
    }

    if(this->isZero())
    {
        Q = BigInt(0);
        R = BigInt(0);
        return;
    }

    if(abs(*this)<abs(D))
    {
        Q = BigInt(0);
        R = *this;
        return;
    }

    R = BigInt(0);
    Q = BigInt(0);

    for(int i = this->size() - 1; i >= 0; i--)
    {
        if(!R.isZero())
        {
            R = R << 1;
        }

        R.d[0] = this->d[i];

        int div = 0;

        while (abs(R) >= abs(D))
        {
            R = R - abs(D);
            div++;
        }

        if(!Q.isZero())
        {
            Q = Q << 1;
        }

        Q.d[0] = div;
    }

    Q.neg = (this->neg != D.neg);

    if (!R.isZero())
    {
        R.neg = this->neg;
    }
}

BigInt operator/(const BigInt& A, const BigInt&B)
{
    BigInt Q, R;
    A.division(B, Q, R);
    return Q;
}

BigInt operator%(const BigInt& A, const BigInt&B)
{
    BigInt Q, R;
    A.division(B, Q, R);
    return R;
}

BigInt::~BigInt()
{
    delete[]d;
}
