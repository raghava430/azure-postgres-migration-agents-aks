--
-- PostgreSQL database dump
--

\restrict ZmpK2rgbwA4H5VlKQe07GbBqLDVuUnUJQohwd6kQ4Xpt5dM5L2fNpfetrYxDg5W

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    customer_name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    city character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_customer_id_seq OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    customer_id integer,
    product_name character varying(100) NOT NULL,
    amount numeric(10,2) NOT NULL,
    order_date date DEFAULT CURRENT_DATE
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_order_id_seq OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, customer_name, email, city, created_at) FROM stdin;
1	Customer 1	customer1@example.com	Los Angeles	2025-10-06 10:30:56.545553
2	Customer 2	customer2@example.com	Chicago	2025-10-06 10:30:56.545553
3	Customer 3	customer3@example.com	Houston	2025-10-06 10:30:56.545553
4	Customer 4	customer4@example.com	Phoenix	2025-10-06 10:30:56.545553
5	Customer 5	customer5@example.com	New York	2025-10-06 10:30:56.545553
6	Customer 6	customer6@example.com	Los Angeles	2025-10-06 10:30:56.545553
7	Customer 7	customer7@example.com	Chicago	2025-10-06 10:30:56.545553
8	Customer 8	customer8@example.com	Houston	2025-10-06 10:30:56.545553
9	Customer 9	customer9@example.com	Phoenix	2025-10-06 10:30:56.545553
10	Customer 10	customer10@example.com	New York	2025-10-06 10:30:56.545553
11	Customer 11	customer11@example.com	Los Angeles	2025-10-06 10:30:56.545553
12	Customer 12	customer12@example.com	Chicago	2025-10-06 10:30:56.545553
13	Customer 13	customer13@example.com	Houston	2025-10-06 10:30:56.545553
14	Customer 14	customer14@example.com	Phoenix	2025-10-06 10:30:56.545553
15	Customer 15	customer15@example.com	New York	2025-10-06 10:30:56.545553
16	Customer 16	customer16@example.com	Los Angeles	2025-10-06 10:30:56.545553
17	Customer 17	customer17@example.com	Chicago	2025-10-06 10:30:56.545553
18	Customer 18	customer18@example.com	Houston	2025-10-06 10:30:56.545553
19	Customer 19	customer19@example.com	Phoenix	2025-10-06 10:30:56.545553
20	Customer 20	customer20@example.com	New York	2025-10-06 10:30:56.545553
21	Customer 21	customer21@example.com	Los Angeles	2025-10-06 10:30:56.545553
22	Customer 22	customer22@example.com	Chicago	2025-10-06 10:30:56.545553
23	Customer 23	customer23@example.com	Houston	2025-10-06 10:30:56.545553
24	Customer 24	customer24@example.com	Phoenix	2025-10-06 10:30:56.545553
25	Customer 25	customer25@example.com	New York	2025-10-06 10:30:56.545553
26	Customer 26	customer26@example.com	Los Angeles	2025-10-06 10:30:56.545553
27	Customer 27	customer27@example.com	Chicago	2025-10-06 10:30:56.545553
28	Customer 28	customer28@example.com	Houston	2025-10-06 10:30:56.545553
29	Customer 29	customer29@example.com	Phoenix	2025-10-06 10:30:56.545553
30	Customer 30	customer30@example.com	New York	2025-10-06 10:30:56.545553
31	Customer 31	customer31@example.com	Los Angeles	2025-10-06 10:30:56.545553
32	Customer 32	customer32@example.com	Chicago	2025-10-06 10:30:56.545553
33	Customer 33	customer33@example.com	Houston	2025-10-06 10:30:56.545553
34	Customer 34	customer34@example.com	Phoenix	2025-10-06 10:30:56.545553
35	Customer 35	customer35@example.com	New York	2025-10-06 10:30:56.545553
36	Customer 36	customer36@example.com	Los Angeles	2025-10-06 10:30:56.545553
37	Customer 37	customer37@example.com	Chicago	2025-10-06 10:30:56.545553
38	Customer 38	customer38@example.com	Houston	2025-10-06 10:30:56.545553
39	Customer 39	customer39@example.com	Phoenix	2025-10-06 10:30:56.545553
40	Customer 40	customer40@example.com	New York	2025-10-06 10:30:56.545553
41	Customer 41	customer41@example.com	Los Angeles	2025-10-06 10:30:56.545553
42	Customer 42	customer42@example.com	Chicago	2025-10-06 10:30:56.545553
43	Customer 43	customer43@example.com	Houston	2025-10-06 10:30:56.545553
44	Customer 44	customer44@example.com	Phoenix	2025-10-06 10:30:56.545553
45	Customer 45	customer45@example.com	New York	2025-10-06 10:30:56.545553
46	Customer 46	customer46@example.com	Los Angeles	2025-10-06 10:30:56.545553
47	Customer 47	customer47@example.com	Chicago	2025-10-06 10:30:56.545553
48	Customer 48	customer48@example.com	Houston	2025-10-06 10:30:56.545553
49	Customer 49	customer49@example.com	Phoenix	2025-10-06 10:30:56.545553
50	Customer 50	customer50@example.com	New York	2025-10-06 10:30:56.545553
51	Customer 51	customer51@example.com	Los Angeles	2025-10-06 10:30:56.545553
52	Customer 52	customer52@example.com	Chicago	2025-10-06 10:30:56.545553
53	Customer 53	customer53@example.com	Houston	2025-10-06 10:30:56.545553
54	Customer 54	customer54@example.com	Phoenix	2025-10-06 10:30:56.545553
55	Customer 55	customer55@example.com	New York	2025-10-06 10:30:56.545553
56	Customer 56	customer56@example.com	Los Angeles	2025-10-06 10:30:56.545553
57	Customer 57	customer57@example.com	Chicago	2025-10-06 10:30:56.545553
58	Customer 58	customer58@example.com	Houston	2025-10-06 10:30:56.545553
59	Customer 59	customer59@example.com	Phoenix	2025-10-06 10:30:56.545553
60	Customer 60	customer60@example.com	New York	2025-10-06 10:30:56.545553
61	Customer 61	customer61@example.com	Los Angeles	2025-10-06 10:30:56.545553
62	Customer 62	customer62@example.com	Chicago	2025-10-06 10:30:56.545553
63	Customer 63	customer63@example.com	Houston	2025-10-06 10:30:56.545553
64	Customer 64	customer64@example.com	Phoenix	2025-10-06 10:30:56.545553
65	Customer 65	customer65@example.com	New York	2025-10-06 10:30:56.545553
66	Customer 66	customer66@example.com	Los Angeles	2025-10-06 10:30:56.545553
67	Customer 67	customer67@example.com	Chicago	2025-10-06 10:30:56.545553
68	Customer 68	customer68@example.com	Houston	2025-10-06 10:30:56.545553
69	Customer 69	customer69@example.com	Phoenix	2025-10-06 10:30:56.545553
70	Customer 70	customer70@example.com	New York	2025-10-06 10:30:56.545553
71	Customer 71	customer71@example.com	Los Angeles	2025-10-06 10:30:56.545553
72	Customer 72	customer72@example.com	Chicago	2025-10-06 10:30:56.545553
73	Customer 73	customer73@example.com	Houston	2025-10-06 10:30:56.545553
74	Customer 74	customer74@example.com	Phoenix	2025-10-06 10:30:56.545553
75	Customer 75	customer75@example.com	New York	2025-10-06 10:30:56.545553
76	Customer 76	customer76@example.com	Los Angeles	2025-10-06 10:30:56.545553
77	Customer 77	customer77@example.com	Chicago	2025-10-06 10:30:56.545553
78	Customer 78	customer78@example.com	Houston	2025-10-06 10:30:56.545553
79	Customer 79	customer79@example.com	Phoenix	2025-10-06 10:30:56.545553
80	Customer 80	customer80@example.com	New York	2025-10-06 10:30:56.545553
81	Customer 81	customer81@example.com	Los Angeles	2025-10-06 10:30:56.545553
82	Customer 82	customer82@example.com	Chicago	2025-10-06 10:30:56.545553
83	Customer 83	customer83@example.com	Houston	2025-10-06 10:30:56.545553
84	Customer 84	customer84@example.com	Phoenix	2025-10-06 10:30:56.545553
85	Customer 85	customer85@example.com	New York	2025-10-06 10:30:56.545553
86	Customer 86	customer86@example.com	Los Angeles	2025-10-06 10:30:56.545553
87	Customer 87	customer87@example.com	Chicago	2025-10-06 10:30:56.545553
88	Customer 88	customer88@example.com	Houston	2025-10-06 10:30:56.545553
89	Customer 89	customer89@example.com	Phoenix	2025-10-06 10:30:56.545553
90	Customer 90	customer90@example.com	New York	2025-10-06 10:30:56.545553
91	Customer 91	customer91@example.com	Los Angeles	2025-10-06 10:30:56.545553
92	Customer 92	customer92@example.com	Chicago	2025-10-06 10:30:56.545553
93	Customer 93	customer93@example.com	Houston	2025-10-06 10:30:56.545553
94	Customer 94	customer94@example.com	Phoenix	2025-10-06 10:30:56.545553
95	Customer 95	customer95@example.com	New York	2025-10-06 10:30:56.545553
96	Customer 96	customer96@example.com	Los Angeles	2025-10-06 10:30:56.545553
97	Customer 97	customer97@example.com	Chicago	2025-10-06 10:30:56.545553
98	Customer 98	customer98@example.com	Houston	2025-10-06 10:30:56.545553
99	Customer 99	customer99@example.com	Phoenix	2025-10-06 10:30:56.545553
100	Customer 100	customer100@example.com	New York	2025-10-06 10:30:56.545553
101	Customer 101	customer101@example.com	Los Angeles	2025-10-06 10:30:56.545553
102	Customer 102	customer102@example.com	Chicago	2025-10-06 10:30:56.545553
103	Customer 103	customer103@example.com	Houston	2025-10-06 10:30:56.545553
104	Customer 104	customer104@example.com	Phoenix	2025-10-06 10:30:56.545553
105	Customer 105	customer105@example.com	New York	2025-10-06 10:30:56.545553
106	Customer 106	customer106@example.com	Los Angeles	2025-10-06 10:30:56.545553
107	Customer 107	customer107@example.com	Chicago	2025-10-06 10:30:56.545553
108	Customer 108	customer108@example.com	Houston	2025-10-06 10:30:56.545553
109	Customer 109	customer109@example.com	Phoenix	2025-10-06 10:30:56.545553
110	Customer 110	customer110@example.com	New York	2025-10-06 10:30:56.545553
111	Customer 111	customer111@example.com	Los Angeles	2025-10-06 10:30:56.545553
112	Customer 112	customer112@example.com	Chicago	2025-10-06 10:30:56.545553
113	Customer 113	customer113@example.com	Houston	2025-10-06 10:30:56.545553
114	Customer 114	customer114@example.com	Phoenix	2025-10-06 10:30:56.545553
115	Customer 115	customer115@example.com	New York	2025-10-06 10:30:56.545553
116	Customer 116	customer116@example.com	Los Angeles	2025-10-06 10:30:56.545553
117	Customer 117	customer117@example.com	Chicago	2025-10-06 10:30:56.545553
118	Customer 118	customer118@example.com	Houston	2025-10-06 10:30:56.545553
119	Customer 119	customer119@example.com	Phoenix	2025-10-06 10:30:56.545553
120	Customer 120	customer120@example.com	New York	2025-10-06 10:30:56.545553
121	Customer 121	customer121@example.com	Los Angeles	2025-10-06 10:30:56.545553
122	Customer 122	customer122@example.com	Chicago	2025-10-06 10:30:56.545553
123	Customer 123	customer123@example.com	Houston	2025-10-06 10:30:56.545553
124	Customer 124	customer124@example.com	Phoenix	2025-10-06 10:30:56.545553
125	Customer 125	customer125@example.com	New York	2025-10-06 10:30:56.545553
126	Customer 126	customer126@example.com	Los Angeles	2025-10-06 10:30:56.545553
127	Customer 127	customer127@example.com	Chicago	2025-10-06 10:30:56.545553
128	Customer 128	customer128@example.com	Houston	2025-10-06 10:30:56.545553
129	Customer 129	customer129@example.com	Phoenix	2025-10-06 10:30:56.545553
130	Customer 130	customer130@example.com	New York	2025-10-06 10:30:56.545553
131	Customer 131	customer131@example.com	Los Angeles	2025-10-06 10:30:56.545553
132	Customer 132	customer132@example.com	Chicago	2025-10-06 10:30:56.545553
133	Customer 133	customer133@example.com	Houston	2025-10-06 10:30:56.545553
134	Customer 134	customer134@example.com	Phoenix	2025-10-06 10:30:56.545553
135	Customer 135	customer135@example.com	New York	2025-10-06 10:30:56.545553
136	Customer 136	customer136@example.com	Los Angeles	2025-10-06 10:30:56.545553
137	Customer 137	customer137@example.com	Chicago	2025-10-06 10:30:56.545553
138	Customer 138	customer138@example.com	Houston	2025-10-06 10:30:56.545553
139	Customer 139	customer139@example.com	Phoenix	2025-10-06 10:30:56.545553
140	Customer 140	customer140@example.com	New York	2025-10-06 10:30:56.545553
141	Customer 141	customer141@example.com	Los Angeles	2025-10-06 10:30:56.545553
142	Customer 142	customer142@example.com	Chicago	2025-10-06 10:30:56.545553
143	Customer 143	customer143@example.com	Houston	2025-10-06 10:30:56.545553
144	Customer 144	customer144@example.com	Phoenix	2025-10-06 10:30:56.545553
145	Customer 145	customer145@example.com	New York	2025-10-06 10:30:56.545553
146	Customer 146	customer146@example.com	Los Angeles	2025-10-06 10:30:56.545553
147	Customer 147	customer147@example.com	Chicago	2025-10-06 10:30:56.545553
148	Customer 148	customer148@example.com	Houston	2025-10-06 10:30:56.545553
149	Customer 149	customer149@example.com	Phoenix	2025-10-06 10:30:56.545553
150	Customer 150	customer150@example.com	New York	2025-10-06 10:30:56.545553
151	Customer 151	customer151@example.com	Los Angeles	2025-10-06 10:30:56.545553
152	Customer 152	customer152@example.com	Chicago	2025-10-06 10:30:56.545553
153	Customer 153	customer153@example.com	Houston	2025-10-06 10:30:56.545553
154	Customer 154	customer154@example.com	Phoenix	2025-10-06 10:30:56.545553
155	Customer 155	customer155@example.com	New York	2025-10-06 10:30:56.545553
156	Customer 156	customer156@example.com	Los Angeles	2025-10-06 10:30:56.545553
157	Customer 157	customer157@example.com	Chicago	2025-10-06 10:30:56.545553
158	Customer 158	customer158@example.com	Houston	2025-10-06 10:30:56.545553
159	Customer 159	customer159@example.com	Phoenix	2025-10-06 10:30:56.545553
160	Customer 160	customer160@example.com	New York	2025-10-06 10:30:56.545553
161	Customer 161	customer161@example.com	Los Angeles	2025-10-06 10:30:56.545553
162	Customer 162	customer162@example.com	Chicago	2025-10-06 10:30:56.545553
163	Customer 163	customer163@example.com	Houston	2025-10-06 10:30:56.545553
164	Customer 164	customer164@example.com	Phoenix	2025-10-06 10:30:56.545553
165	Customer 165	customer165@example.com	New York	2025-10-06 10:30:56.545553
166	Customer 166	customer166@example.com	Los Angeles	2025-10-06 10:30:56.545553
167	Customer 167	customer167@example.com	Chicago	2025-10-06 10:30:56.545553
168	Customer 168	customer168@example.com	Houston	2025-10-06 10:30:56.545553
169	Customer 169	customer169@example.com	Phoenix	2025-10-06 10:30:56.545553
170	Customer 170	customer170@example.com	New York	2025-10-06 10:30:56.545553
171	Customer 171	customer171@example.com	Los Angeles	2025-10-06 10:30:56.545553
172	Customer 172	customer172@example.com	Chicago	2025-10-06 10:30:56.545553
173	Customer 173	customer173@example.com	Houston	2025-10-06 10:30:56.545553
174	Customer 174	customer174@example.com	Phoenix	2025-10-06 10:30:56.545553
175	Customer 175	customer175@example.com	New York	2025-10-06 10:30:56.545553
176	Customer 176	customer176@example.com	Los Angeles	2025-10-06 10:30:56.545553
177	Customer 177	customer177@example.com	Chicago	2025-10-06 10:30:56.545553
178	Customer 178	customer178@example.com	Houston	2025-10-06 10:30:56.545553
179	Customer 179	customer179@example.com	Phoenix	2025-10-06 10:30:56.545553
180	Customer 180	customer180@example.com	New York	2025-10-06 10:30:56.545553
181	Customer 181	customer181@example.com	Los Angeles	2025-10-06 10:30:56.545553
182	Customer 182	customer182@example.com	Chicago	2025-10-06 10:30:56.545553
183	Customer 183	customer183@example.com	Houston	2025-10-06 10:30:56.545553
184	Customer 184	customer184@example.com	Phoenix	2025-10-06 10:30:56.545553
185	Customer 185	customer185@example.com	New York	2025-10-06 10:30:56.545553
186	Customer 186	customer186@example.com	Los Angeles	2025-10-06 10:30:56.545553
187	Customer 187	customer187@example.com	Chicago	2025-10-06 10:30:56.545553
188	Customer 188	customer188@example.com	Houston	2025-10-06 10:30:56.545553
189	Customer 189	customer189@example.com	Phoenix	2025-10-06 10:30:56.545553
190	Customer 190	customer190@example.com	New York	2025-10-06 10:30:56.545553
191	Customer 191	customer191@example.com	Los Angeles	2025-10-06 10:30:56.545553
192	Customer 192	customer192@example.com	Chicago	2025-10-06 10:30:56.545553
193	Customer 193	customer193@example.com	Houston	2025-10-06 10:30:56.545553
194	Customer 194	customer194@example.com	Phoenix	2025-10-06 10:30:56.545553
195	Customer 195	customer195@example.com	New York	2025-10-06 10:30:56.545553
196	Customer 196	customer196@example.com	Los Angeles	2025-10-06 10:30:56.545553
197	Customer 197	customer197@example.com	Chicago	2025-10-06 10:30:56.545553
198	Customer 198	customer198@example.com	Houston	2025-10-06 10:30:56.545553
199	Customer 199	customer199@example.com	Phoenix	2025-10-06 10:30:56.545553
200	Customer 200	customer200@example.com	New York	2025-10-06 10:30:56.545553
201	Customer 201	customer201@example.com	Los Angeles	2025-10-06 10:30:56.545553
202	Customer 202	customer202@example.com	Chicago	2025-10-06 10:30:56.545553
203	Customer 203	customer203@example.com	Houston	2025-10-06 10:30:56.545553
204	Customer 204	customer204@example.com	Phoenix	2025-10-06 10:30:56.545553
205	Customer 205	customer205@example.com	New York	2025-10-06 10:30:56.545553
206	Customer 206	customer206@example.com	Los Angeles	2025-10-06 10:30:56.545553
207	Customer 207	customer207@example.com	Chicago	2025-10-06 10:30:56.545553
208	Customer 208	customer208@example.com	Houston	2025-10-06 10:30:56.545553
209	Customer 209	customer209@example.com	Phoenix	2025-10-06 10:30:56.545553
210	Customer 210	customer210@example.com	New York	2025-10-06 10:30:56.545553
211	Customer 211	customer211@example.com	Los Angeles	2025-10-06 10:30:56.545553
212	Customer 212	customer212@example.com	Chicago	2025-10-06 10:30:56.545553
213	Customer 213	customer213@example.com	Houston	2025-10-06 10:30:56.545553
214	Customer 214	customer214@example.com	Phoenix	2025-10-06 10:30:56.545553
215	Customer 215	customer215@example.com	New York	2025-10-06 10:30:56.545553
216	Customer 216	customer216@example.com	Los Angeles	2025-10-06 10:30:56.545553
217	Customer 217	customer217@example.com	Chicago	2025-10-06 10:30:56.545553
218	Customer 218	customer218@example.com	Houston	2025-10-06 10:30:56.545553
219	Customer 219	customer219@example.com	Phoenix	2025-10-06 10:30:56.545553
220	Customer 220	customer220@example.com	New York	2025-10-06 10:30:56.545553
221	Customer 221	customer221@example.com	Los Angeles	2025-10-06 10:30:56.545553
222	Customer 222	customer222@example.com	Chicago	2025-10-06 10:30:56.545553
223	Customer 223	customer223@example.com	Houston	2025-10-06 10:30:56.545553
224	Customer 224	customer224@example.com	Phoenix	2025-10-06 10:30:56.545553
225	Customer 225	customer225@example.com	New York	2025-10-06 10:30:56.545553
226	Customer 226	customer226@example.com	Los Angeles	2025-10-06 10:30:56.545553
227	Customer 227	customer227@example.com	Chicago	2025-10-06 10:30:56.545553
228	Customer 228	customer228@example.com	Houston	2025-10-06 10:30:56.545553
229	Customer 229	customer229@example.com	Phoenix	2025-10-06 10:30:56.545553
230	Customer 230	customer230@example.com	New York	2025-10-06 10:30:56.545553
231	Customer 231	customer231@example.com	Los Angeles	2025-10-06 10:30:56.545553
232	Customer 232	customer232@example.com	Chicago	2025-10-06 10:30:56.545553
233	Customer 233	customer233@example.com	Houston	2025-10-06 10:30:56.545553
234	Customer 234	customer234@example.com	Phoenix	2025-10-06 10:30:56.545553
235	Customer 235	customer235@example.com	New York	2025-10-06 10:30:56.545553
236	Customer 236	customer236@example.com	Los Angeles	2025-10-06 10:30:56.545553
237	Customer 237	customer237@example.com	Chicago	2025-10-06 10:30:56.545553
238	Customer 238	customer238@example.com	Houston	2025-10-06 10:30:56.545553
239	Customer 239	customer239@example.com	Phoenix	2025-10-06 10:30:56.545553
240	Customer 240	customer240@example.com	New York	2025-10-06 10:30:56.545553
241	Customer 241	customer241@example.com	Los Angeles	2025-10-06 10:30:56.545553
242	Customer 242	customer242@example.com	Chicago	2025-10-06 10:30:56.545553
243	Customer 243	customer243@example.com	Houston	2025-10-06 10:30:56.545553
244	Customer 244	customer244@example.com	Phoenix	2025-10-06 10:30:56.545553
245	Customer 245	customer245@example.com	New York	2025-10-06 10:30:56.545553
246	Customer 246	customer246@example.com	Los Angeles	2025-10-06 10:30:56.545553
247	Customer 247	customer247@example.com	Chicago	2025-10-06 10:30:56.545553
248	Customer 248	customer248@example.com	Houston	2025-10-06 10:30:56.545553
249	Customer 249	customer249@example.com	Phoenix	2025-10-06 10:30:56.545553
250	Customer 250	customer250@example.com	New York	2025-10-06 10:30:56.545553
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, customer_id, product_name, amount, order_date) FROM stdin;
1	2	Product 1	12.24	2025-10-05
2	3	Product 2	36.27	2025-10-04
3	4	Product 3	435.85	2025-10-03
4	5	Product 4	190.33	2025-10-02
5	6	Product 5	51.42	2025-10-01
6	7	Product 6	248.04	2025-09-30
7	8	Product 7	387.87	2025-09-29
8	9	Product 8	493.88	2025-09-28
9	10	Product 9	201.64	2025-09-27
10	11	Product 10	415.29	2025-09-26
11	12	Product 11	205.21	2025-09-25
12	13	Product 12	405.82	2025-09-24
13	14	Product 13	109.77	2025-09-23
14	15	Product 14	213.24	2025-09-22
15	16	Product 15	289.56	2025-09-21
16	17	Product 16	342.76	2025-09-20
17	18	Product 17	381.51	2025-09-19
18	19	Product 18	235.38	2025-09-18
19	20	Product 19	229.45	2025-09-17
20	21	Product 20	366.58	2025-09-16
21	22	Product 21	193.89	2025-09-15
22	23	Product 22	450.62	2025-09-14
23	24	Product 23	75.81	2025-09-13
24	25	Product 24	77.59	2025-09-12
25	26	Product 25	179.95	2025-09-11
26	27	Product 26	192.88	2025-09-10
27	28	Product 27	76.31	2025-09-09
28	29	Product 28	15.71	2025-09-08
29	30	Product 29	256.02	2025-09-07
30	31	Product 30	111.37	2025-09-06
31	32	Product 31	53.74	2025-09-05
32	33	Product 32	86.45	2025-09-04
33	34	Product 33	42.66	2025-09-03
34	35	Product 34	448.11	2025-09-02
35	36	Product 35	384.66	2025-09-01
36	37	Product 36	167.41	2025-08-31
37	38	Product 37	335.02	2025-08-30
38	39	Product 38	277.40	2025-08-29
39	40	Product 39	265.84	2025-08-28
40	41	Product 40	333.73	2025-08-27
41	42	Product 41	138.88	2025-08-26
42	43	Product 42	60.29	2025-08-25
43	44	Product 43	347.48	2025-08-24
44	45	Product 44	493.65	2025-08-23
45	46	Product 45	212.81	2025-08-22
46	47	Product 46	131.21	2025-08-21
47	48	Product 47	28.23	2025-08-20
48	49	Product 48	68.33	2025-08-19
49	50	Product 49	237.12	2025-08-18
50	51	Product 0	181.30	2025-08-17
51	52	Product 1	73.19	2025-08-16
52	53	Product 2	214.30	2025-08-15
53	54	Product 3	94.27	2025-08-14
54	55	Product 4	122.36	2025-08-13
55	56	Product 5	66.45	2025-08-12
56	57	Product 6	193.53	2025-08-11
57	58	Product 7	365.16	2025-08-10
58	59	Product 8	387.83	2025-08-09
59	60	Product 9	383.14	2025-08-08
60	61	Product 10	232.25	2025-08-07
61	62	Product 11	297.27	2025-08-06
62	63	Product 12	360.03	2025-08-05
63	64	Product 13	260.67	2025-08-04
64	65	Product 14	162.93	2025-08-03
65	66	Product 15	120.37	2025-08-02
66	67	Product 16	422.57	2025-08-01
67	68	Product 17	471.56	2025-07-31
68	69	Product 18	437.77	2025-07-30
69	70	Product 19	358.36	2025-07-29
70	71	Product 20	419.67	2025-07-28
71	72	Product 21	81.63	2025-07-27
72	73	Product 22	303.26	2025-07-26
73	74	Product 23	103.34	2025-07-25
74	75	Product 24	267.49	2025-07-24
75	76	Product 25	184.09	2025-07-23
76	77	Product 26	297.13	2025-07-22
77	78	Product 27	219.49	2025-07-21
78	79	Product 28	69.45	2025-07-20
79	80	Product 29	183.01	2025-07-19
80	81	Product 30	284.55	2025-07-18
81	82	Product 31	11.16	2025-07-17
82	83	Product 32	487.45	2025-07-16
83	84	Product 33	433.04	2025-07-15
84	85	Product 34	346.09	2025-07-14
85	86	Product 35	111.61	2025-07-13
86	87	Product 36	248.86	2025-07-12
87	88	Product 37	507.19	2025-07-11
88	89	Product 38	303.03	2025-07-10
89	90	Product 39	326.19	2025-07-09
90	91	Product 40	169.19	2025-07-08
91	92	Product 41	243.92	2025-07-07
92	93	Product 42	199.35	2025-07-06
93	94	Product 43	345.19	2025-07-05
94	95	Product 44	300.41	2025-07-04
95	96	Product 45	325.81	2025-07-03
96	97	Product 46	367.17	2025-07-02
97	98	Product 47	121.48	2025-07-01
98	99	Product 48	426.65	2025-06-30
99	100	Product 49	443.58	2025-06-29
100	101	Product 0	382.75	2025-06-28
101	102	Product 1	205.41	2025-06-27
102	103	Product 2	474.03	2025-06-26
103	104	Product 3	411.09	2025-06-25
104	105	Product 4	293.04	2025-06-24
105	106	Product 5	261.20	2025-06-23
106	107	Product 6	419.08	2025-06-22
107	108	Product 7	290.50	2025-06-21
108	109	Product 8	482.95	2025-06-20
109	110	Product 9	485.92	2025-06-19
110	111	Product 10	173.15	2025-06-18
111	112	Product 11	450.08	2025-06-17
112	113	Product 12	198.60	2025-06-16
113	114	Product 13	508.20	2025-06-15
114	115	Product 14	423.38	2025-06-14
115	116	Product 15	429.55	2025-06-13
116	117	Product 16	89.01	2025-06-12
117	118	Product 17	464.21	2025-06-11
118	119	Product 18	266.63	2025-06-10
119	120	Product 19	115.80	2025-06-09
120	121	Product 20	346.61	2025-06-08
121	122	Product 21	260.14	2025-06-07
122	123	Product 22	300.46	2025-06-06
123	124	Product 23	25.68	2025-06-05
124	125	Product 24	273.47	2025-06-04
125	126	Product 25	128.08	2025-06-03
126	127	Product 26	380.76	2025-06-02
127	128	Product 27	355.19	2025-06-01
128	129	Product 28	351.17	2025-05-31
129	130	Product 29	269.67	2025-05-30
130	131	Product 30	329.90	2025-05-29
131	132	Product 31	467.08	2025-05-28
132	133	Product 32	23.49	2025-05-27
133	134	Product 33	173.47	2025-05-26
134	135	Product 34	80.57	2025-05-25
135	136	Product 35	175.21	2025-05-24
136	137	Product 36	501.32	2025-05-23
137	138	Product 37	213.48	2025-05-22
138	139	Product 38	335.84	2025-05-21
139	140	Product 39	253.69	2025-05-20
140	141	Product 40	443.80	2025-05-19
141	142	Product 41	484.26	2025-05-18
142	143	Product 42	132.78	2025-05-17
143	144	Product 43	77.15	2025-05-16
144	145	Product 44	446.40	2025-05-15
145	146	Product 45	338.52	2025-05-14
146	147	Product 46	144.94	2025-05-13
147	148	Product 47	429.41	2025-05-12
148	149	Product 48	288.90	2025-05-11
149	150	Product 49	473.34	2025-05-10
150	151	Product 0	304.36	2025-05-09
151	152	Product 1	337.28	2025-05-08
152	153	Product 2	42.34	2025-05-07
153	154	Product 3	316.56	2025-05-06
154	155	Product 4	175.52	2025-05-05
155	156	Product 5	295.51	2025-05-04
156	157	Product 6	140.70	2025-05-03
157	158	Product 7	307.98	2025-05-02
158	159	Product 8	227.67	2025-05-01
159	160	Product 9	41.23	2025-04-30
160	161	Product 10	428.31	2025-04-29
161	162	Product 11	505.31	2025-04-28
162	163	Product 12	402.40	2025-04-27
163	164	Product 13	367.58	2025-04-26
164	165	Product 14	108.63	2025-04-25
165	166	Product 15	438.35	2025-04-24
166	167	Product 16	318.00	2025-04-23
167	168	Product 17	258.43	2025-04-22
168	169	Product 18	20.97	2025-04-21
169	170	Product 19	375.96	2025-04-20
170	171	Product 20	436.50	2025-04-19
171	172	Product 21	155.61	2025-04-18
172	173	Product 22	190.55	2025-04-17
173	174	Product 23	493.70	2025-04-16
174	175	Product 24	327.32	2025-04-15
175	176	Product 25	421.16	2025-04-14
176	177	Product 26	355.18	2025-04-13
177	178	Product 27	140.67	2025-04-12
178	179	Product 28	116.00	2025-04-11
179	180	Product 29	505.80	2025-04-10
180	181	Product 30	456.38	2025-04-09
181	182	Product 31	465.73	2025-04-08
182	183	Product 32	420.77	2025-04-07
183	184	Product 33	31.41	2025-04-06
184	185	Product 34	213.13	2025-04-05
185	186	Product 35	132.69	2025-04-04
186	187	Product 36	208.90	2025-04-03
187	188	Product 37	447.87	2025-04-02
188	189	Product 38	70.98	2025-04-01
189	190	Product 39	431.72	2025-03-31
190	191	Product 40	373.45	2025-03-30
191	192	Product 41	504.58	2025-03-29
192	193	Product 42	92.60	2025-03-28
193	194	Product 43	340.52	2025-03-27
194	195	Product 44	244.98	2025-03-26
195	196	Product 45	470.52	2025-03-25
196	197	Product 46	188.20	2025-03-24
197	198	Product 47	146.68	2025-03-23
198	199	Product 48	324.75	2025-03-22
199	200	Product 49	496.70	2025-03-21
200	201	Product 0	99.39	2025-03-20
201	202	Product 1	39.14	2025-03-19
202	203	Product 2	220.46	2025-03-18
203	204	Product 3	191.98	2025-03-17
204	205	Product 4	123.07	2025-03-16
205	206	Product 5	376.33	2025-03-15
206	207	Product 6	306.91	2025-03-14
207	208	Product 7	486.19	2025-03-13
208	209	Product 8	431.04	2025-03-12
209	210	Product 9	349.88	2025-03-11
210	211	Product 10	485.09	2025-03-10
211	212	Product 11	119.97	2025-03-09
212	213	Product 12	247.88	2025-03-08
213	214	Product 13	67.79	2025-03-07
214	215	Product 14	318.14	2025-03-06
215	216	Product 15	12.16	2025-03-05
216	217	Product 16	28.07	2025-03-04
217	218	Product 17	46.49	2025-03-03
218	219	Product 18	402.80	2025-03-02
219	220	Product 19	465.61	2025-03-01
220	221	Product 20	287.14	2025-02-28
221	222	Product 21	405.31	2025-02-27
222	223	Product 22	240.37	2025-02-26
223	224	Product 23	460.51	2025-02-25
224	225	Product 24	464.98	2025-02-24
225	226	Product 25	216.78	2025-02-23
226	227	Product 26	334.89	2025-02-22
227	228	Product 27	185.16	2025-02-21
228	229	Product 28	277.50	2025-02-20
229	230	Product 29	347.01	2025-02-19
230	231	Product 30	119.82	2025-02-18
231	232	Product 31	349.50	2025-02-17
232	233	Product 32	418.60	2025-02-16
233	234	Product 33	95.46	2025-02-15
234	235	Product 34	273.43	2025-02-14
235	236	Product 35	472.77	2025-02-13
236	237	Product 36	54.84	2025-02-12
237	238	Product 37	146.06	2025-02-11
238	239	Product 38	47.36	2025-02-10
239	240	Product 39	28.18	2025-02-09
240	241	Product 40	400.85	2025-02-08
241	242	Product 41	315.26	2025-02-07
242	243	Product 42	403.10	2025-02-06
243	244	Product 43	388.74	2025-02-05
244	245	Product 44	495.94	2025-02-04
245	246	Product 45	81.63	2025-02-03
246	247	Product 46	440.62	2025-02-02
247	248	Product 47	95.47	2025-02-01
248	249	Product 48	499.14	2025-01-31
249	250	Product 49	307.12	2025-01-30
250	1	Product 0	138.27	2025-01-29
\.


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 250, true);


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 250, true);


--
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- PostgreSQL database dump complete
--

\unrestrict ZmpK2rgbwA4H5VlKQe07GbBqLDVuUnUJQohwd6kQ4Xpt5dM5L2fNpfetrYxDg5W

