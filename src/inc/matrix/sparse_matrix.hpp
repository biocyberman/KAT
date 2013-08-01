#pragma once

#include <cstdlib>
#include <map>
#include <vector>
#include <iostream>

using std::endl;

template <class T>
class SparseMatrix
{
public:
    typedef std::map<size_t, std::map<size_t , T> > mat_t;
    typedef typename mat_t::iterator row_iter;
    typedef std::map<size_t, T> col_t;
    typedef typename col_t::iterator col_iter;

    SparseMatrix(size_t i){ m=i; n=i; }
    SparseMatrix(size_t i, size_t j){ m=i; n=j; }

    inline
    T& operator()(size_t i, size_t j)
    {
        if(i>=m || j>=n) throw;
        return mat[i][j];
    }
    inline
    T operator()(size_t i, size_t j) const
    {
        if(i>=m || j>=n) throw;
        return mat[i][j];
    }

    T inc(size_t i, size_t j, T val)
    {
        mat[i][j] = mat[i][j] + val;
        return mat[i][j];
    }

    T get(size_t i, size_t j)
    {
        if(i>=m || j>=n) throw;
        return mat[i][j];
    }

    size_t width()   {return m;}
    size_t height()  {return n;}

    T getMaxVal()
    {
        T maxVal = 0;

        for(int i = 0; i < m; i++)
        {
            for(int j = 0; j < n; j++)
            {
                maxVal = maxVal < mat[i][j] ? mat[i][j] : maxVal;
            }
        }

        return maxVal;
    }

    std::vector<T> operator*(const std::vector<T>& x)
    {  //Computes y=A*x
        if(this->m != x.size()) throw;

        std::vector<T> y(this->m);
        T sum;

        row_iter ii;
        col_iter jj;

        for(ii=this->mat.begin(); ii!=this->mat.end(); ii++){
            sum=0;
            for(jj=(*ii).second.begin(); jj!=(*ii).second.end(); jj++){
                sum += (*jj).second * x[(*jj).first];
            }
            y[(*ii).first]=sum;
        }

        return y;
    }

    void printMat()
    {
        row_iter ii;
        col_iter jj;
        for(ii=this->mat.begin(); ii!=this->mat.end(); ii++){
            for( jj=(*ii).second.begin(); jj!=(*ii).second.end(); jj++){
                std::cout << (*ii).first << ' ';
                std::cout << (*jj).first << ' ';
                std::cout << (*jj).second << std::endl;
            }
        } std::cout << std::endl;
    }

    void printMatrix(std::ostream &out)
    {
        for(int i = 0; i < m; i++)
        {
            out << mat[i][0];

            for(int j = 1; j < n; j++)
            {
                out << " " << mat[i][j];
            }

            out << endl;
        }
    }
    
protected:
    SparseMatrix(){}

private:
    mat_t mat;
    size_t m;
    size_t n;
};