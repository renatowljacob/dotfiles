/* See LICENSE file for copyright and license details. */

typedef struct {
	Cursor cursor;
} Cur;

typedef struct Fnt {
	Display *dpy;
	unsigned int h;
	XftFont *xfont;
	FcPattern *pattern;
	struct Fnt *next;
} Fnt;

enum { ColFg, ColBg, ColBorder, ColCount }; /* Clr scheme index */
enum { PwrlNone, PwrlRightArrow, PwrlLeftArrow, PwrlForwardSlash, PwrlBackslash, PwrlSolid, PwrlSolidRev };
typedef XftColor Clr;

typedef struct {
	unsigned int w, h;
	Display *dpy;
	int screen;
	Window root;
	Visual *visual;
	unsigned int depth;
	Colormap cmap;
	Drawable drawable;
	Picture picture;
	GC gc;
	Clr *scheme;
	Fnt *fonts;
} Drw;

/* Drawable abstraction */
Drw *drw_create(Display *dpy, int screen, Window win, unsigned int w, unsigned int h, Visual *visual, unsigned int depth, Colormap cmap);
void drw_resize(Drw *drw, unsigned int w, unsigned int h);
void drw_free(Drw *drw);

/* Fnt abstraction */
Fnt *drw_fontset_create(Drw* drw, const char *fonts[], size_t fontcount);
void drw_fontset_free(Fnt* set);
unsigned int drw_fontset_getwidth(Drw *drw, const char *text);
unsigned int drw_fontset_getwidth_clamp(Drw *drw, const char *text, unsigned int n);

/* Colorscheme abstraction */
void drw_clr_create(
	Drw *drw,
	Clr *dest,
	const char *clrname,
	unsigned int alpha
);
Clr *drw_scm_create(
	Drw *drw,
	char *clrnames[],
	unsigned int alphas[],
	size_t clrcount
);

/* Cursor abstraction */
Cur *drw_cur_create(Drw *drw, int shape);
void drw_cur_free(Drw *drw, Cur *cursor);

/* Drawing context manipulation */
void drw_setfontset(Drw *drw, Fnt *set);
void drw_setscheme(Drw *drw, Clr *scm);

/* Drawing functions */
void drw_rect(Drw *drw, int x, int y, unsigned int w, unsigned int h, int filled, int invert);
int drw_text(Drw *drw, int x, int y, unsigned int w, unsigned int h, unsigned int lpad, const char *text, int invert, int fillbg);
void drw_arrow(Drw *drw, int x, int y, unsigned int w, unsigned int h, int style, Clr prev, Clr next, Clr separator);

/* Map functions */
void drw_map(Drw *drw, Window win, int x, int y, unsigned int w, unsigned int h);
