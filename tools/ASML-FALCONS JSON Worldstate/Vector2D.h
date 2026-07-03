// from http://www.terathon.com/code/vector2d.html


#include <math.h>


class Vector2D
{
    public:
    
        float   x;
        float   y;
        
        Vector2D() {}
        
        Vector2D(float r, float s)
        {
            x = r;
            y = s;
        }

        Vector2D& Set(float r, float s)
        {
            x = r;
            y = s;
            return (*this);
        }
        
        float& operator [](long k)
        {
            return ((&x)[k]);
        }
        
        const float& operator [](long k) const
        {
            return ((&x)[k]);
        }
        
        Vector2D& operator +=(const Vector2D& v)
        {
            x += v.x;
            y += v.y;
            return (*this);
        }
        
        Vector2D& operator -=(const Vector2D& v)
        {
            x -= v.x;
            y -= v.y;
            return (*this);
        }
        
        Vector2D& operator *=(float t)
        {
            x *= t;
            y *= t;
            return (*this);
        }
        
        Vector2D& operator /=(float t)
        {
            float f = 1.0F / t;
            x *= f;
            y *= f;
            return (*this);
        }
        
        Vector2D& operator &=(const Vector2D& v)
        {
            x *= v.x;
            y *= v.y;
            return (*this);
        }
        
        Vector2D operator -(void) const
        {
            return (Vector2D(-x, -y));
        }
        
        Vector2D operator +(const Vector2D& v) const
        {
            return (Vector2D(x + v.x, y + v.y));
        }
        
        Vector2D operator -(const Vector2D& v) const
        {
            return (Vector2D(x - v.x, y - v.y));
        }
        
        Vector2D operator *(float t) const
        {
            return (Vector2D(x * t, y * t));
        }
        
        Vector2D operator /(float t) const
        {
            float f = 1.0F / t;
            return (Vector2D(x * f, y * f));
        }
        
        float operator *(const Vector2D& v) const
        {
            return (x * v.x + y * v.y);
        }
        
        Vector2D operator &(const Vector2D& v) const
        {
            return (Vector2D(x * v.x, y * v.y));
        }
        
        bool operator ==(const Vector2D& v) const
        {
            return ((x == v.x) && (y == v.y));
        }
        
        bool operator !=(const Vector2D& v) const
        {
            return ((x != v.x) || (y != v.y));
        }
        
        Vector2D& Normalize(void)
        {
            return (*this /= sqrtf(x * x + y * y));
        }
        
        Vector2D& Rotate(float angle);
};


class Vector3D
{
public:
    
    float   x;
    float   y;
    float   z;
    
    Vector3D() {}
    
    Vector3D(float r, float s, float t)
    {
        x = r;
        y = s;
        z = t;
    }
    
    Vector3D(const Vector2D& v, float u)
    {
        x = v.x;
        y = v.y;
        z = u;
    }
    
    Vector3D& Set(float r, float s, float t)
    {
        x = r;
        y = s;
        z = t;
        return (*this);
    }
    
    Vector3D& Set(const Vector2D& v, float u)
    {
        x = v.x;
        y = v.y;
        z = u;
        return (*this);
    }
    
    float& operator [](long k)
    {
        return ((&x)[k]);
    }
    
    const float& operator [](long k) const
    {
        return ((&x)[k]);
    }
    
    Vector3D& operator =(const Vector2D& v)
    {
        x = v.x;
        y = v.y;
        z = 0.0F;
        return (*this);
    }
    
    Vector3D& operator +=(const Vector3D& v)
    {
        x += v.x;
        y += v.y;
        z += v.z;
        return (*this);
    }
    
    Vector3D& operator +=(const Vector2D& v)
    {
        x += v.x;
        y += v.y;
        return (*this);
    }
    
    Vector3D& operator -=(const Vector3D& v)
    {
        x -= v.x;
        y -= v.y;
        z -= v.z;
        return (*this);
    }
    
    Vector3D& operator -=(const Vector2D& v)
    {
        x -= v.x;
        y -= v.y;
        return (*this);
    }
    
    Vector3D& operator *=(float t)
    {
        x *= t;
        y *= t;
        z *= t;
        return (*this);
    }
    
    Vector3D& operator /=(float t)
    {
        float f = 1.0F / t;
        x *= f;
        y *= f;
        z *= f;
        return (*this);
    }
    
    Vector3D& operator %=(const Vector3D& v)
    {
        float       r, s;
        
        r = y * v.z - z * v.y;
        s = z * v.x - x * v.z;
        z = x * v.y - y * v.x;
        x = r;
        y = s;
        
        return (*this);
    }
    
    Vector3D& operator &=(const Vector3D& v)
    {
        x *= v.x;
        y *= v.y;
        z *= v.z;
        return (*this);
    }
    
    Vector3D operator -(void) const
    {
        return (Vector3D(-x, -y, -z));
    }
    
    Vector3D operator +(const Vector3D& v) const
    {
        return (Vector3D(x + v.x, y + v.y, z + v.z));
    }
    
    Vector3D operator +(const Vector2D& v) const
    {
        return (Vector3D(x + v.x, y + v.y, z));
    }
    
    Vector3D operator -(const Vector3D& v) const
    {
        return (Vector3D(x - v.x, y - v.y, z - v.z));
    }
    
    Vector3D operator -(const Vector2D& v) const
    {
        return (Vector3D(x - v.x, y - v.y, z));
    }
    
    Vector3D operator *(float t) const
    {
        return (Vector3D(x * t, y * t, z * t));
    }
    
    Vector3D operator /(float t) const
    {
        float f = 1.0F / t;
        return (Vector3D(x * f, y * f, z * f));
    }
    
    float operator *(const Vector3D& v) const
    {
        return (x * v.x + y * v.y + z * v.z);
    }
    
    float operator *(const Vector2D& v) const
    {
        return (x * v.x + y * v.y);
    }
    
    Vector3D operator %(const Vector3D& v) const
    {
        return (Vector3D(y * v.z - z * v.y, z * v.x - x * v.z,
                         x * v.y - y * v.x));
    }
    
    Vector3D operator &(const Vector3D& v) const
    {
        return (Vector3D(x * v.x, y * v.y, z * v.z));
    }
    
    bool operator ==(const Vector3D& v) const
    {
        return ((x == v.x) && (y == v.y) && (z == v.z));
    }
    
    bool operator !=(const Vector3D& v) const
    {
        return ((x != v.x) || (y != v.y) || (z != v.z));
    }
    
    Vector3D& Normalize(void)
    {
        return (*this /= sqrtf(x * x + y * y + z * z));
    }
    
};